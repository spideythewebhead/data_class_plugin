import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';

class JsonKeyInternal {
  const JsonKeyInternal({
    this.name,
    this.fromJson,
    this.toJson,
    this.ignore = false,
  });

  final String? name;
  final ExecutableElement? fromJson;
  final ExecutableElement? toJson;
  final bool ignore;

  factory JsonKeyInternal.fromDartObject(DartObject? object) {
    if (object == null) {
      return const JsonKeyInternal();
    }
    return JsonKeyInternal(
      name: object.getField('name')?.toStringValue(),
      fromJson: object.getField('fromJson')?.toFunctionValue(),
      toJson: object.getField('toJson')?.toFunctionValue(),
      ignore: object.getField('ignore')?.toBoolValue() ?? false,
    );
  }

  /// Returns a string with the properties of [this]
  @override
  String toString() {
    return """JsonKeyInternal(
<name= $name>,
<fromJson= $fromJson>,
<toJson= $toJson>,
<ignore= $ignore>,
)""";
  }
}
