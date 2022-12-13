import 'package:data_class_plugin/data_class_plugin.dart';

part 'simple_usage.gen.dart';

@DataClass(
  toJson: true,
  fromJson: false,
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

  /// Converts [User] to a [Map] json
  Map<String, dynamic> toJson();
}
