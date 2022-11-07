import 'package:analyzer/dart/constant/value.dart';

class UnionInternal {
  /// Shorthand constructor
  const UnionInternal({
    this.dataClass = true,
    this.fromJson = true,
    this.toJson = true,
  });

  final bool dataClass;
  final bool fromJson;
  final bool toJson;

  factory UnionInternal.fromDartObject(DartObject? object) {
    if (object == null) {
      return const UnionInternal();
    }

    return UnionInternal(
      dataClass: object.getField('dataClass')?.toBoolValue() ?? true,
      fromJson: object.getField('fromJson')?.toBoolValue() ?? true,
      toJson: object.getField('toJson')?.toBoolValue() ?? true,
    );
  }
}

/// Default value for union constructor parameter
class DefaultValue<T> {
  const DefaultValue(this.value);

  final T value;
}
