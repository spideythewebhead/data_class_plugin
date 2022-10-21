import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';

class MapKeyInternal {
  const MapKeyInternal({
    this.name,
    this.fromMap,
    this.toMap,
    this.ignore = false,
    this.readValue,
    this.unknownEnumValue,
  });

  final String? name;
  final ExecutableElement? fromMap;
  final ExecutableElement? toMap;
  final bool ignore;
  final ExecutableElement? readValue;
  final String? unknownEnumValue;

  factory MapKeyInternal.fromDartObject(DartObject? object) {
    if (object == null) {
      return const MapKeyInternal();
    }
    return MapKeyInternal(
      name: object.getField('name')?.toStringValue(),
      fromMap: object.getField('fromMap')?.toFunctionValue(),
      toMap: object.getField('toMap')?.toFunctionValue(),
      ignore: object.getField('ignore')?.toBoolValue() ?? false,
      readValue: object.getField('readValue')?.toFunctionValue(),
      // unknownEnumValue:
    );
  }

  @override
  String toString() {
    return """MapKeyInternal(
<name= $name>,
<fromMap= $fromMap>,
<toMap= $toMap>,
<ignore= $ignore>,
<readValue= $readValue>,
<unknownEnumValue= $unknownEnumValue>,
)""";
  }
}
