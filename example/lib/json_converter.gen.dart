// AUTO GENERATED - DO NOT MODIFY

part of 'json_converter.dart';

class _$MyClassImpl extends MyClass {
  _$MyClassImpl({
    required this.datetime,
    required this.uri,
    required this.latLng,
  }) : super._();

  @override
  final DateTime datetime;

  @override
  final Uri uri;

  @override
  final LatLng latLng;

  factory _$MyClassImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$MyClassImpl(
      datetime: jsonConverterRegistrant
          .find(DateTime)
          .fromJson(json['datetime']) as DateTime,
      uri: jsonConverterRegistrant.find(Uri).fromJson(json['uri']) as Uri,
      latLng: jsonConverterRegistrant.find(LatLng).fromJson(json['latLng'])
          as LatLng,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'datetime': jsonConverterRegistrant.find(Duration).toJson(datetime),
      'uri': jsonConverterRegistrant.find(Duration).toJson(uri),
      'latLng': jsonConverterRegistrant.find(Duration).toJson(latLng),
    };
  }
}
