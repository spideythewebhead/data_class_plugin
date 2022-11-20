import 'package:data_class_plugin/data_class_plugin.dart';

@DataClass(
  copyWith: true,
  $toString: false,
  hashAndEquals: false,
  fromJson: false,
  toJson: false,
)
class CopyWithTest {}

// Should create a [copyWith] method
