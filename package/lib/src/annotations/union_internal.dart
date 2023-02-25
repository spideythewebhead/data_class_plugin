import 'package:analyzer/dart/constant/value.dart';

class UnionInternal {
  const UnionInternal({
    this.copyWith,
    this.hashAndEquals,
    this.$toString,
    this.fromJson,
    this.toJson,
  });

  final bool? copyWith;
  final bool? hashAndEquals;
  final bool? $toString;
  final bool? fromJson;
  final bool? toJson;

  factory UnionInternal.fromDartObject(DartObject? object) {
    return UnionInternal(
      copyWith: object?.getField('copyWith')?.toBoolValue(),
      hashAndEquals: object?.getField('hashAndEquals')?.toBoolValue(),
      $toString: object?.getField('\$toString')?.toBoolValue(),
      fromJson: object?.getField('fromJson')?.toBoolValue(),
      toJson: object?.getField('toJson')?.toBoolValue(),
    );
  }
}

/// Default value for union constructor parameter
class DefaultValue<T> {
  const DefaultValue(this.value);

  final T value;
}
