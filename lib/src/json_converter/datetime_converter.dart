part of 'json_converter.dart';

class _DateTimeJsonConverter implements JsonConverter<DateTime, String> {
  const _DateTimeJsonConverter();

  @override
  @pragma('vm:prefer-inline')
  String toJson(DateTime value) => value.toIso8601String();

  @override
  @pragma('vm:prefer-inline')
  DateTime fromJson(String value, Map<dynamic, dynamic> json, String keyName) =>
      DateTime.parse(value);
}
