import 'package:data_class_plugin/public/annotations.dart';

@DataClass(
  fromJson: true,
  toJson: false,
  copyWith: false,
  $toString: false,
  hashAndEquals: false,
)
class User {
  /// Shorthand constructor
  User({
    required this.thisIsAVariable,
    required this.thisIsADifferentVariable,
  });

  final String thisIsAVariable;
  final String thisIsADifferentVariable;

  /// Creates an instance of [User] from [json]
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      thisIsAVariable: json['this_is_a_variable'] as String,
      thisIsADifferentVariable: json['this_is_a_different_variable'] as String,
    );
  }
}
