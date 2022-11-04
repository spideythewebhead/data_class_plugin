part of 'json_converter.dart';

class _DurationJsonConverter implements JsonConverter<Duration, String> {
  const _DurationJsonConverter();

  @override
  String toJson(Duration value) => value.toString();

  @override
  Duration fromJson(String value) {
    final List<String> parts = value.split(':');

    int hours = 0;
    int minutes = 0;
    int microseconds;

    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    microseconds = (double.parse(parts[parts.length - 1]) * 1000000).round();

    return Duration(
      hours: hours,
      minutes: minutes,
      microseconds: microseconds,
    );
  }
}
