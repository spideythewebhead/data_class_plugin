import 'package:data_class_plugin/public/annotations.dart';

const String _appId = 'app_id';

class User {
  User({
    required this.id,
    required this.username,
  }) : appId = _appId;

  @MapKey(name: '_id')
  final String id;

  @MapKey(fromJson: _usernameConverter)
  final String username;

  @MapKey(ignore: true)
  final String appId;

  // fields with initial values are ignored
  final int isSpecial = 0;

  static String _usernameConverter(Map<String, dynamic> json) {
    return json['username'] ?? json['uname'];
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String,
      username: User._usernameConverter(json),
    );
  }
}
