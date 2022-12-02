import 'package:data_class_plugin/data_class_plugin.dart';

@Union()
class UnionWithDefaultValues {
  const factory UnionWithDefaultValues.impl({
    @UnionFieldValue<String>('') String value2,
    @UnionFieldValue<int>(0) int value4,
    @UnionFieldValue<bool>(true) bool value5,
  }) = Impl;
}
