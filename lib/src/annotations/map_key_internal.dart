import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';

class MapKeyInternal {
  const MapKeyInternal({
    this.name,
    this.fromJson,
    this.toJson,
    this.ignore = false,
    this.readValue,
    this.unknownEnumValue,
  });

  final String? name;
  final ExecutableElement? fromJson;
  final ExecutableElement? toJson;
  final bool ignore;
  final ExecutableElement? readValue;
  final String? unknownEnumValue;

  factory MapKeyInternal.fromDartObject(DartObject? object) {
    if (object == null) {
      return const MapKeyInternal();
    }
    return MapKeyInternal(
      name: object.getField('name')?.toStringValue(),
      fromJson: object.getField('fromMap')?.toFunctionValue(),
      toJson: object.getField('toMap')?.toFunctionValue(),
      ignore: object.getField('ignore')?.toBoolValue() ?? false,
      readValue: object.getField('readValue')?.toFunctionValue(),
      // unknownEnumValue:
    );
  }

  @override
  String toString() {
    return """MapKeyInternal(
<name= $name>,
<fromJson= $fromJson>,
<toJson= $toJson>,
<ignore= $ignore>,
<readValue= $readValue>,
<unknownEnumValue= $unknownEnumValue>,
)""";
  }
}
