import 'package:data_class_plugin/public/annotations.dart';

const String _appId = 'app_id';

class User {
  User({
    required this.id,
    required this.username,
  }) : appId = _appId;

  @MapKey(name: '_id')
  final String id;

  @MapKey(fromMap: _usernameConverter)
  final String username;

  @MapKey(ignore: true)
  final String appId;

  // fields with initial values are ignored
  final int isSpecial = 0;

  static String _usernameConverter(Map<String, dynamic> map) {
    return map['username'] ?? map['uname'];
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as String,
      username: User._usernameConverter(map),
    );
  }
}
