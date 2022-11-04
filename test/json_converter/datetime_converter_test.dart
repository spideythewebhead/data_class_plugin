import 'package:data_class_plugin/src/json_converter/json_converter.dart';
import 'package:test/test.dart';

class _TestModel {
  /// Shorthand constructor
  _TestModel({
    required this.dateTime,
  });

  final DateTime dateTime;

  /// Creates an instance of [_TestModel] from [json]
  factory _TestModel.fromJson(Map<String, dynamic> json) {
    return _TestModel(
      dateTime: jsonConverterRegistrant.find(DateTime).fromJson(json['dateTime']) as DateTime,
    );
  }

  /// Converts [_TestModel] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'dateTime': jsonConverterRegistrant.find(DateTime).toJson(dateTime),
    };
  }

  /// Returns a hash code based on [this] properties
  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      dateTime,
    ]);
  }

  /// Compares [this] with [other] on identity, class type, and properties
  /// *with deep comparison on collections*
  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is _TestModel && dateTime == other.dateTime;
  }
}

void main() {
  group('Datetime json converter', () {
    final DateTime dateTime = DateTime(2022, 10, 4, 3, 20, 232);
    final Map<String, dynamic> json = <String, dynamic>{'dateTime': dateTime.toIso8601String()};
    final _TestModel testModel = _TestModel(dateTime: dateTime);

    test('toJson', () => expect(testModel.toJson(), json));

    test('fromJson', () => expect(_TestModel.fromJson(json), testModel));
  });
}
