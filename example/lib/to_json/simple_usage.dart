import 'package:data_class_plugin/public/annotations.dart';

@DataClass(
  toJson: true,
  fromJson: false,
  copyWith: false,
  hashAndEquals: false,
  $toString: false,
)
class User {
  /// Shorthand constructor
  User({
    required this.id,
    required this.username,
    this.email,
  });

  final String id;
  final String username;
  final String? email;

  /// Converts [User] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
    };
  }
}

@DataClass(
  toJson: true,
  fromJson: false,
  copyWith: false,
  hashAndEquals: false,
  $toString: false,
)
class GetUsersResponse {
  /// Shorthand constructor
  GetUsersResponse({
    required this.ok,
    required this.users,
  });

  final bool ok;
  final List<User> users;

  /// Converts [GetUsersResponse] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'ok': ok,
      'users': <dynamic>[
        for (final User i0 in users) i0.toJson(),
      ],
    };
  }
}
