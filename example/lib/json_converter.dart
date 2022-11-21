import 'package:data_class_plugin/data_class_plugin.dart';

part 'json_converter.gen.dart';

// Assume this is in external package
class LatLng {
  LatLng({
    required this.lat,
    required this.lng,
  });

  final double lat;
  final double lng;

  /// Returns a string with the properties of [LatLng]
  @override
  String toString() {
    String value = 'LatLng{<optimized out>}';
    assert(() {
      value = 'LatLng@<$hexIdentity>{lat: $lat, lng: $lng}';
      return true;
    }());
    return value;
  }
}

// Create a custom converter
class LatLngConverter implements JsonConverter<LatLng, String> {
  const LatLngConverter();

  @override
  String toJson(LatLng value) {
    return '${value.lat}|${value.lng}';
  }

  @override
  LatLng fromJson(String value) {
    final values = value.split('|').map(double.parse).toList(growable: false);
    return LatLng(lat: values[0], lng: values[1]);
  }
}

@DataClass(
  $toString: false,
  copyWith: false,
  hashAndEquals: false,
  fromJson: true,
  toJson: true,
)
abstract class MyClass {
  MyClass._();

  /// Default constructor
  factory MyClass({
    required DateTime datetime,
    required Uri uri,
    required LatLng latLng,
  }) = _$MyClassImpl;

  // DateTime and Uri are supported out of the box
  DateTime get datetime;
  Uri get uri;
  LatLng get latLng;

  /// Creates an instance of [MyClass] from [json]
  factory MyClass.fromJson(Map<dynamic, dynamic> json) = _$MyClassImpl.fromJson;

  /// Converts [MyClass] to a [Map] json
  Map<String, dynamic> toJson();
}

void main() {
  jsonConverterRegistrant.register(const LatLngConverter());

  final o = MyClass.fromJson(
    <String, dynamic>{
      'datetime': DateTime.now().toIso8601String(),
      'uri': 'https://google.com',
      'latLng': '0.01|0.99',
    },
  );

  print(o);
}
