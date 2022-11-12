import 'package:analyzer/dart/constant/value.dart';
import 'package:data_class_plugin/src/annotations/data_class.dart';

@DataClass()
class DataClassInternal {
  /// Shorthand constructor
  const DataClassInternal({
    required this.copyWith,
    required this.hashAndEquals,
    required this.$toString,
    required this.fromJson,
    required this.toJson,
  });

  final bool copyWith;
  final bool hashAndEquals;
  final bool $toString;
  final bool fromJson;
  final bool toJson;

  factory DataClassInternal.fromDartObject(DartObject? object) {
    return DataClassInternal(
      copyWith: object?.getField('copyWith')?.toBoolValue() ?? true,
      hashAndEquals: object?.getField('hashAndEquals')?.toBoolValue() ?? true,
      $toString: object?.getField('\$toString')?.toBoolValue() ?? true,
      fromJson: object?.getField('fromJson')?.toBoolValue() ?? false,
      toJson: object?.getField('toJson')?.toBoolValue() ?? false,
    );
  }
}
