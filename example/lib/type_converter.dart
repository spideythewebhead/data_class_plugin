import 'package:data_class_plugin/public/type_converter.dart';

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
class LatLngConverter implements TypeConverter<LatLng, String> {
  const LatLngConverter();

  @override
  String toMap(LatLng value) {
    return '${value.lat}|${value.lng}';
  }

  @override
  LatLng fromMap(String value) {
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

  factory MyClass.fromMap(Map<String, dynamic> map) {
    return MyClass(
      datetime: typeConverterRegistrant.find(DateTime).fromMap(map['datetime'])
          as DateTime,
      uri: typeConverterRegistrant.find(Uri).fromMap(map['uri']) as Uri,
      latLng:
          typeConverterRegistrant.find(LatLng).fromMap(map['latLng']) as LatLng,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'datetime': typeConverterRegistrant.find(DateTime).toMap(datetime),
      'uri': typeConverterRegistrant.find(Uri).toMap(uri),
      'latLng': typeConverterRegistrant.find(LatLng).toMap(latLng),
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
  typeConverterRegistrant.register(const LatLngConverter());

  final o = MyClass.fromMap(<String, dynamic>{
    'datetime': DateTime.now().toIso8601String(),
    'uri': 'https://google.com',
    'latLng': '0.01|0.99'
  });

  print(o);
}
