part of 'json_converter.dart';

class _UriJsonConverter implements JsonConverter<Uri, String> {
  const _UriJsonConverter();

  @override
  String toJson(Uri value) => value.toString();

  @override
  Uri fromJson(String value) => Uri.parse(value);
}
