part of 'json_converter.dart';

class _DateTimeJsonConverter implements JsonConverter<DateTime, String> {
  const _DateTimeJsonConverter();

  @override
  String toJson(DateTime value) => value.toIso8601String();

  @override
  DateTime fromJson(String value) => DateTime.parse(value);
}
