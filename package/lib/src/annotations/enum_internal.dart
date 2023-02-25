import 'package:analyzer/dart/constant/value.dart';

class EnumInternal {
  /// Shorthand constructor
  const EnumInternal({
    required this.$toString,
    required this.fromJson,
    required this.toJson,
  });

  final bool? $toString;
  final bool? fromJson;
  final bool? toJson;

  factory EnumInternal.fromDartObject(DartObject? object) {
    return EnumInternal(
      $toString: object?.getField('\$toString')?.toBoolValue(),
      fromJson: object?.getField('fromJson')?.toBoolValue(),
      toJson: object?.getField('toJson')?.toBoolValue(),
    );
  }
}
