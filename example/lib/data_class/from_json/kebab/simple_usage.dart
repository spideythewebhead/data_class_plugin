import 'package:data_class_plugin/data_class_plugin.dart';

part 'simple_usage.gen.dart';

@DataClass(
  fromJson: true,
  toJson: false,
  copyWith: false,
  $toString: false,
  hashAndEquals: false,
)
abstract class User {
  User._();

  /// Default constructor
  factory User({
    required String thisIsAVariable,
    required String thisIsADifferentVariable,
  }) = _$UserImpl;

  String get thisIsAVariable;
  String get thisIsADifferentVariable;

  /// Creates an instance of [User] from [json]
  factory User.fromJson(Map<dynamic, dynamic> json) = _$UserImpl.fromJson;
}
