import 'package:data_class_plugin/data_class_plugin.dart';

part 'default_value_usage.gen.dart';

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
    Map<String, User> friends,
  }) = _$UserImpl;

  @DefaultValue(<String, User>{})
  Map<String, User> get friends;

  /// Creates an instance of [User] from [json]
  factory User.fromJson(Map<dynamic, dynamic> json) = _$UserImpl.fromJson;
}
