import 'package:analyzer/dart/constant/value.dart';

class JsonKey {
  const JsonKey({
    this.disallowNullValue,
    this.fromJson,
    this.ignore = false,
    this.includeIfNull,
    this.name,
    this.readValue,
    this.required = false,
    this.toJson,
    this.unknownEnumValue,
  });

  final bool? disallowNullValue;
  final String? fromJson;
  final bool ignore;
  final bool? includeIfNull;
  final String? name;
  final String? readValue;
  final bool? required;
  final String? toJson;
  final String? unknownEnumValue;

  factory JsonKey.fromDartObject(DartObject? object) {
    if (object == null) {
      return const JsonKey();
    }
    return JsonKey(
      disallowNullValue: object.getField('disallowNullValue')?.toBoolValue(),
      fromJson:
          object.getField('fromJson')?.toTypeValue()?.element2?.displayName,
      ignore: object.getField('ignore')?.toBoolValue() ?? false,
      includeIfNull: object.getField('includeIfNull')?.toBoolValue(),
      name: object.getField('name')?.toStringValue(),
      // readValue: object.getField('readValue')?.toStringValue(),
      required: object.getField('required')?.toBoolValue(),
      toJson: object.getField('toJson')?.toStringValue(),
      // unknownEnumValue:
    );
  }

  @override
  String toString() {
    return """JsonKey(
<disallowNullValue= $disallowNullValue>,
<fromJson= $fromJson>,
<ignore= $ignore>,
<includeIfNull= $includeIfNull>,
<name= $name>,
<readValue= $readValue>,
<required= $required>,
<toJson= $toJson>,
<unknownEnumValue= $unknownEnumValue>,
)""";
  }
}
