import 'package:data_class_plugin/data_class_plugin.dart';

@DataClass(
  $toString: true,
  copyWith: false,
  hashAndEquals: false,
  fromJson: false,
  toJson: false,
)
class ToStringTest {}
