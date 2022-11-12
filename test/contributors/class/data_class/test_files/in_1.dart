import 'package:data_class_plugin/public/annotations.dart';

@DataClass(
  $toString: true,
  copyWith: false,
  hashAndEquals: false,
  fromJson: false,
  toJson: false,
)
class ToStringTest {}
