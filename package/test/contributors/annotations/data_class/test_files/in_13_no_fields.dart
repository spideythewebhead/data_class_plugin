import 'package:data_class_plugin/data_class_plugin.dart';

@DataClass(
  fromJson: true,
  copyWith: true,
  hashAndEquals: false,
  toJson: false,
  $toString: false,
)
class User {
  /// Shorthand constructor
  User();
}

// Should not add '// ignore: prefer_const_constructors'
// when constructor is const with no fields
