import 'package:data_class_plugin/data_class_plugin.dart';

@Union()
class UnionWithDefaultValues {
  const factory UnionWithDefaultValues.impl({
    @DefaultValue<String>('') String value2,
    @DefaultValue<int>(0) int value4,
    @DefaultValue<bool>(true) bool value5,
  }) = Impl;
}
