import 'dart:convert';

import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:test/test.dart';

enum Colors {
  red,
  green,
  blue;
}

class ColorsConverter implements JsonConverter<Colors, String> {
  const ColorsConverter();

  @override
  Colors fromJson(String value, Map<dynamic, dynamic> json, String keyName) {
    return Colors.values.firstWhere((Colors c) => c.name == value);
  }

  @override
  String toJson(Colors value) => value.name;
}

@DataClass(
  $toString: false,
  copyWith: false,
  hashAndEquals: false,
  fromJson: true,
  toJson: true,
)
class _TestModel {
  /// Shorthand constructor
  _TestModel({
    required this.colors,
  });

  final Colors colors;

  /// Converts [_TestModel] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'colors': jsonConverterRegistrant.find(Colors).toJson(colors),
    };
  }

  /// Creates an instance of [_TestModel] from [json]
  factory _TestModel.fromJson(Map<dynamic, dynamic> json) {
    return _TestModel(
      colors:
          jsonConverterRegistrant.find(Colors).fromJson(json['colors'], json, 'colors') as Colors,
    );
  }
}

void main() {
  const Colors color = Colors.green;
  final Map<String, dynamic> json = <String, dynamic>{'colors': color.name};

  group('Registered enum json converter', () {
    final _TestModel mockModel = _TestModel(colors: color);
    setUp(() => jsonConverterRegistrant.register(const ColorsConverter()));

    test('toJson', () {
      expect(mockModel.toJson(), json);
      expect(jsonEncode(mockModel), jsonEncode(json));
    });

    test('fromJson', () {
      expect(_TestModel.fromJson(json).colors, color);
    });
  });

  group('Unregistered enum json converter', () {
    final _TestModel model = _TestModel(colors: color);
    setUp(() => jsonConverterRegistrant.unregister(const ColorsConverter()));

    test('toJson - throws Exception if not registered', () {
      expect(
        () => model.toJson(),
        throwsA(isA<Exception>()),
      );
    });

    test('fromJson - throws Exception if not registered', () {
      expect(
        () => _TestModel.fromJson(<String, dynamic>{}),
        throwsA(isA<Exception>()),
      );
    });
  });
}
