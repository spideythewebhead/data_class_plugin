import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:file_generation_mode/pretty_print.dart';

part 'custom_json_converter.gen.dart';

@DataClass(
  toJson: true,
)
abstract class LogRecord {
  LogRecord.ctor();

  /// Default constructor
  factory LogRecord({
    required String text,
    required DateTime datetime,
  }) = _$LogRecordImpl;

  String get text;

  @_DateTimeFromSecondsJsonConverter()
  DateTime get datetime;

  /// Converts [LogRecord] to a [Map] json
  Map<String, dynamic> toJson();
}

class _DateTimeFromSecondsJsonConverter implements JsonConverter<DateTime, int> {
  const _DateTimeFromSecondsJsonConverter();

  @override
  DateTime fromJson(int value, Map<dynamic, dynamic> json, String keyName) {
    // check examples/file_generation_mode/lib/data_class/from_json/custom_json_converter.dart
    throw UnimplementedError();
  }

  @override
  int toJson(DateTime value) {
    return (value.millisecondsSinceEpoch / 1000).floor();
  }
}

void main(List<String> args) {
  final LogRecord logRecord = LogRecord(
    text: 'log text',
    datetime: DateTime.now(),
  );

  prettyPrint('log record toJson', logRecord.toJson());
}
