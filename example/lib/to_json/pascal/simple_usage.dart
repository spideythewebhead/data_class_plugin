import 'package:data_class_plugin/public/annotations.dart';

@DataClass(
  toJson: true,
  fromJson: false,
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

  /// Converts [User] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'ThisIsAVariable': thisIsAVariable,
      'ThisIsADifferentVariable': thisIsADifferentVariable,
    };
  }
}
