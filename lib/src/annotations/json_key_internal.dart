import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';

class JsonKeyInternal {
  const JsonKeyInternal({
    this.name,
    this.fromJson,
    this.toJson,
    this.ignore = false,
    this.nameConvention,
  });

  final String? name;
  final ExecutableElement? fromJson;
  final ExecutableElement? toJson;
  final bool ignore;
  final String? nameConvention;

  factory JsonKeyInternal.fromDartObject(DartObject? object) {
    return JsonKeyInternal(
      name: object?.getField('name')?.toStringValue(),
      fromJson: object?.getField('fromJson')?.toFunctionValue(),
      toJson: object?.getField('toJson')?.toFunctionValue(),
      ignore: object?.getField('ignore')?.toBoolValue() ?? false,
      nameConvention: object?.getField('nameConvention')?.variable?.name,
    );
  }
}
