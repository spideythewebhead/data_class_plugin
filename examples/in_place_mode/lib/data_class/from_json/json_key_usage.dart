import 'package:data_class_plugin/data_class_plugin.dart';

@DataClass(
  fromJson: true,
  toJson: false,
  copyWith: false,
  hashAndEquals: false,
  $toString: false,
)
class User {
  /// Shorthand constructor
  User({
    required this.id,
    required this.username,
    this.appId = 'app_id',
  });

  @JsonKey<String>(name: '_id')
  final String id;

  @JsonKey<String>(fromJson: _usernameConverter)
  final String username;

  @JsonKey<String>(ignore: true)
  final String appId;

  // fields with initial values are ignored
  final int isSpecial = 0;

  static String _usernameConverter(dynamic value, Map<dynamic, dynamic> json, String keyName) {
    return value ?? '';
  }

  /// Creates an instance of [User] from [json]
  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
      id: json['_id'] as String,
      username: User._usernameConverter(json['username'], json, 'username'),
    );
  }
}
