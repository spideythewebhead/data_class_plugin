class User {
  User({
    required this.id,
    required this.username,
    this.email,
  });

  final String id;
  final String username;
  final String? email;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
    };
  }
}

class GetUsersResponse {
  GetUsersResponse({
    required this.ok,
    required this.users,
  });

  final bool ok;
  final List<User> users;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ok': ok,
      'users': <dynamic>[
        for (final User i0 in users) i0.toMap(),
      ],
    };
  }
}
