part of 'json_converter.dart';

class _UriJsonConverter implements JsonConverter<Uri, String> {
  const _UriJsonConverter();

  @override
  @pragma('vm:prefer-inline')
  String toJson(Uri value) => value.toString();

  @override
  @pragma('vm:prefer-inline')
  Uri fromJson(String value, Map<dynamic, dynamic> json, String keyName) => Uri.parse(value);
}
