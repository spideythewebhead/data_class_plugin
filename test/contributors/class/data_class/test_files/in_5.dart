import 'package:data_class_plugin/data_class_plugin.dart';

@DataClass(
  toJson: true,
  fromJson: false,
  hashAndEquals: false,
  copyWith: false,
  $toString: false,
)
class ToJsonTest {}

// Should create a [toJson] method
