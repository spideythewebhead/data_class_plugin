import 'package:analyzer/dart/constant/value.dart';

class DataClassInternal {
  const DataClassInternal({
    required this.copyWith,
    required this.hashAndEquals,
    required this.$toString,
    required this.fromJson,
    required this.toJson,
  });

  final bool? copyWith;
  final bool? hashAndEquals;
  final bool? $toString;
  final bool? fromJson;
  final bool? toJson;

  factory DataClassInternal.fromDartObject(DartObject? object) {
    return DataClassInternal(
      copyWith: object?.getField('copyWith')?.toBoolValue(),
      hashAndEquals: object?.getField('hashAndEquals')?.toBoolValue(),
      $toString: object?.getField('\$toString')?.toBoolValue(),
      fromJson: object?.getField('fromJson')?.toBoolValue(),
      toJson: object?.getField('toJson')?.toBoolValue(),
    );
  }
}
