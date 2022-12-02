import 'package:analyzer/dart/constant/value.dart';

class UnionInternal {
  const UnionInternal({
    required this.dataClass,
    required this.fromJson,
    required this.toJson,
  });

  final bool? dataClass;
  final bool? fromJson;
  final bool? toJson;

  factory UnionInternal.fromDartObject(DartObject? object) {
    return UnionInternal(
      dataClass: object?.getField('dataClass')?.toBoolValue(),
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
