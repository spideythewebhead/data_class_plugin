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
  const User();
}

// Should add '// ignore: prefer_const_constructors' in CopyWith()
// when constructor is const with no fields
// and create a 'fromJson' factory that returns a const instance
