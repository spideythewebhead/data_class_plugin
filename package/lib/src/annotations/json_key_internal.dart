import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element2.dart';

class JsonKeyInternal {
  const JsonKeyInternal({
    this.name,
    this.fromJson,
    this.toJson,
    this.ignore = false,
    this.nameConvention,
  });

  final String? name;
  final ExecutableElement2? fromJson;
  final ExecutableElement2? toJson;
  final bool ignore;
  final String? nameConvention;

  factory JsonKeyInternal.fromDartObject(DartObject? object) {
    return JsonKeyInternal(
      name: object?.getField('name')?.toStringValue(),
      fromJson: object?.getField('fromJson')?.toFunctionValue2(),
      toJson: object?.getField('toJson')?.toFunctionValue2(),
      ignore: object?.getField('ignore')?.toBoolValue() ?? false,
      nameConvention: object?.getField('nameConvention')?.variable2?.name3,
    );
  }
}
