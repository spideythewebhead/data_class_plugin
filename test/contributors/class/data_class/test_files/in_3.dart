import 'package:data_class_plugin/public/annotations.dart';

@DataClass(
  hashAndEquals: true,
  copyWith: false,
  $toString: false,
  fromJson: false,
  toJson: false,
)
class HashAndEqualsTest {}

// Should create a [hashCode] override method and [operator ==] override method
