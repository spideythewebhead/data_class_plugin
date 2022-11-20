import 'package:data_class_plugin/data_class_plugin.dart';

@DataClass(
  fromJson: true,
  hashAndEquals: false,
  copyWith: false,
  $toString: false,
  toJson: false,
)
class FromJsonTest {}

// Should create a [fromJson] factory constructor
