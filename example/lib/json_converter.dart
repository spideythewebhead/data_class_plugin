import 'package:data_class_plugin/public/json_converter.dart';

// Assume this is in external package
class LatLng {
  LatLng({
    required this.lat,
    required this.lng,
  });

  final double lat;
  final double lng;

  @override
  String toString() {
    return """LatLng(
<lat= $lat>,
<lng= $lng>,
)""";
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

class MyClass {
  MyClass({
    required this.datetime,
    required this.uri,
    required this.latLng,
  });

  // DateTime and Uri are supported out of the box
  final DateTime datetime;
  final Uri uri;
  final LatLng latLng;

  /// Creates an instance of [MyClass] from [json]
  factory MyClass.fromJson(Map<String, dynamic> json) {
    return MyClass(
      datetime: jsonConverterRegistrant.find(DateTime).fromJson(json['datetime']) as DateTime,
      uri: jsonConverterRegistrant.find(Uri).fromJson(json['uri']) as Uri,
      latLng: jsonConverterRegistrant.find(LatLng).fromJson(json['latLng']) as LatLng,
    );
  }

  /// Converts [MyClass] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'datetime': jsonConverterRegistrant.find(DateTime).toJson(datetime),
      'uri': jsonConverterRegistrant.find(Uri).toJson(uri),
      'latLng': jsonConverterRegistrant.find(LatLng).toJson(latLng),
    };
  }

  @override
  String toString() {
    return """MyClass(
<datetime= $datetime>,
<uri= $uri>,
<latLng= $latLng>,
)""";
  }
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
