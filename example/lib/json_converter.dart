import 'package:data_class_plugin/data_class_plugin.dart';

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
  LatLng fromJson(String value, Map<dynamic, dynamic> json, String keyName) {
    final List<double> values = value.split('|').map(double.parse).toList(growable: false);
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
class ClassWithLatLngField {
  /// Shorthand constructor
  ClassWithLatLngField({
    required this.datetime,
    required this.uri,
    required this.latLng,
  });

  // DateTime and Uri are supported out of the box
  final DateTime datetime;
  final Uri uri;
  final LatLng latLng;

  /// Creates an instance of [ClassWithLatLngField] from [json]
  factory ClassWithLatLngField.fromJson(Map<dynamic, dynamic> json) {
    return ClassWithLatLngField(
      datetime: jsonConverterRegistrant.find(DateTime).fromJson(json['datetime'], json, 'datetime')
          as DateTime,
      uri: jsonConverterRegistrant.find(Uri).fromJson(json['uri'], json, 'uri') as Uri,
      latLng:
          jsonConverterRegistrant.find(LatLng).fromJson(json['latLng'], json, 'latLng') as LatLng,
    );
  }

  /// Converts [ClassWithLatLngField] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'datetime': jsonConverterRegistrant.find(DateTime).toJson(datetime),
      'uri': jsonConverterRegistrant.find(Uri).toJson(uri),
      'latLng': jsonConverterRegistrant.find(LatLng).toJson(latLng),
    };
  }
}

@DataClass(
  $toString: false,
  copyWith: false,
  hashAndEquals: false,
  fromJson: true,
  toJson: true,
)
class ClassWithLatLngConverterAnnotation {
  /// Shorthand constructor
  ClassWithLatLngConverterAnnotation({
    required this.datetime,
    required this.uri,
    required this.latLng,
  });

  // DateTime and Uri are supported out of the box
  final DateTime datetime;
  final Uri uri;

  @LatLngConverter()
  final LatLng latLng;

  /// Creates an instance of [ClassWithLatLngConverterAnnotation] from [json]
  factory ClassWithLatLngConverterAnnotation.fromJson(Map<dynamic, dynamic> json) {
    return ClassWithLatLngConverterAnnotation(
      datetime: jsonConverterRegistrant.find(DateTime).fromJson(json['datetime'], json, 'datetime')
          as DateTime,
      uri: jsonConverterRegistrant.find(Uri).fromJson(json['uri'], json, 'uri') as Uri,
      latLng: const LatLngConverter().fromJson(json['latLng'], json, 'latLng'),
    );
  }

  /// Converts [ClassWithLatLngConverterAnnotation] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'datetime': jsonConverterRegistrant.find(DateTime).toJson(datetime),
      'uri': jsonConverterRegistrant.find(Uri).toJson(uri),
      'latLng': const LatLngConverter().toJson(latLng),
    };
  }
}

void main() {
  jsonConverterRegistrant.register(const LatLngConverter());

  final ClassWithLatLngField o = ClassWithLatLngField.fromJson(
    <String, dynamic>{
      'datetime': DateTime.now().toIso8601String(),
      'uri': 'https://google.com',
      'latLng': '0.01|0.99',
    },
  );

  print(o);
}
