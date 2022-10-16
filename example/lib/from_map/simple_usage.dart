class User {
  User({
    required this.id,
    required this.username,
  });

  final String id;
  final String username;

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      username: map['username'] as String,
    );
  }
}
