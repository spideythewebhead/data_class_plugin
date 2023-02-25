import 'package:analyzer/dart/constant/value.dart';

class DataClassInternal {
  /// Shorthand constructor
  const DataClassInternal({
    this.copyWith,
    this.hashAndEquals,
    this.$toString,
    this.fromJson,
    this.toJson,
    this.constructorName,
  });

  final bool? copyWith;
  final bool? hashAndEquals;
  final bool? $toString;
  final bool? fromJson;
  final bool? toJson;
  final String? constructorName;

  factory DataClassInternal.fromDartObject(DartObject? object) {
    return DataClassInternal(
      copyWith: object?.getField('copyWith')?.toBoolValue(),
      hashAndEquals: object?.getField('hashAndEquals')?.toBoolValue(),
      $toString: object?.getField('\$toString')?.toBoolValue(),
      fromJson: object?.getField('fromJson')?.toBoolValue(),
      toJson: object?.getField('toJson')?.toBoolValue(),
      constructorName: object?.getField('constructorName')?.toStringValue(),
    );
  }
}
