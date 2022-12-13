import 'package:data_class_plugin/data_class_plugin.dart';

part 'json_key_usage.gen.dart';

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
    required String id,
    required String username,
  }) = _$UserImpl;

  @JsonKey<String>(name: '_id')
  String get id;

  @JsonKey<String>(fromJson: User._usernameConverter)
  String get username;

  // fields with initial values are ignored
  final int isSpecial = 0;

  static String _usernameConverter(Map<dynamic, dynamic> json) {
    return json['username'] ?? json['uname'];
  }

  /// Creates an instance of [User] from [json]
  factory User.fromJson(Map<dynamic, dynamic> json) = _$UserImpl.fromJson;
}
