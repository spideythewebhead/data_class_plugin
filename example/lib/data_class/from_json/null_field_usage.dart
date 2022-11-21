import 'package:data_class_plugin/data_class_plugin.dart';

part 'null_field_usage.gen.dart';

@DataClass(
  fromJson: true,
  toJson: false,
  copyWith: false,
  hashAndEquals: false,
  $toString: false,
)
abstract class User {
  User._();

  /// Default constructor
  factory User({
    String? avatarUrl,
  }) = _$UserImpl;

  String? get avatarUrl;

  /// Creates an instance of [User] from [json]
  factory User.fromJson(Map<dynamic, dynamic> json) = _$UserImpl.fromJson;
}
