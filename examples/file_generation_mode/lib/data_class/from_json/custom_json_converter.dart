import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:file_generation_mode/pretty_print.dart';

part 'custom_json_converter.gen.dart';

@DataClass(
  fromJson: true,
)
abstract class LogRecord {
  LogRecord.ctor();

  /// Default constructor
  factory LogRecord({
    required String text,
    required DateTime datetime,
  }) = _$LogRecordImpl;

  /// Creates an instance of [LogRecord] from [json]
  factory LogRecord.fromJson(Map<dynamic, dynamic> json) = _$LogRecordImpl.fromJson;

  String get text;

  @JsonKey(name: 'timestampInSeconds')
  @_DateTimeFromSecondsJsonConverter()
  DateTime get datetime;
}

class _DateTimeFromSecondsJsonConverter implements JsonConverter<DateTime, int> {
  const _DateTimeFromSecondsJsonConverter();

  @override
  DateTime fromJson(int value, Map<dynamic, dynamic> json, String keyName) {
    return value < 0 ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(value * 1000);
  }

  @override
  int toJson(DateTime value) {
    // check examples/file_generation_mode/lib/data_class/to_json/custom_json_converter.dart
    throw UnimplementedError();
  }
}

void main(List<String> args) {
  final LogRecord logRecord = LogRecord.fromJson(<String, dynamic>{
    'text': 'log text',
    'timestampInSeconds': 1682456812,
  });

  prettyPrint('log record fromJson', logRecord);
}
