import 'dart:convert';

import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:test/test.dart';

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
    required this.duration,
  });

  final Duration duration;

  /// Creates an instance of [_TestModel] from [json]
  factory _TestModel.fromJson(Map<dynamic, dynamic> json) {
    return _TestModel(
      duration: jsonConverterRegistrant.find(Duration).fromJson(json['duration'], json, 'duration')
          as Duration,
    );
  }

  /// Converts [_TestModel] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'duration': jsonConverterRegistrant.find(Duration).toJson(duration),
    };
  }
}

void main() {
  const Duration mockDuration = Duration(
    days: 1,
    hours: 2,
    minutes: 3,
    seconds: 4,
    milliseconds: 5,
    microseconds: 6,
  );
  const Map<String, dynamic> mockJson = <String, dynamic>{
    'duration': '26:03:04.005006',
  };

  group('Test duration json converter', () {
    test('toJson', () {
      final _TestModel mock = _TestModel(duration: mockDuration);
      expect(mock.toJson(), mockJson);
      expect(jsonEncode(mock), jsonEncode(mockJson));
    });

    test('fromJson', () {
      final _TestModel mock = _TestModel.fromJson(mockJson);
      expect(mock.duration, mockDuration);
    });
  });
}
