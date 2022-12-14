import 'package:data_class_plugin/data_class_plugin.dart';

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
  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
      thisIsAVariable: json['this-is-a-variable'] as String,
      thisIsADifferentVariable: json['this-is-a-different-variable'] as String,
    );
  }
}
