class User {
  User({
    required this.id,
    required this.username,
  });

  final String id;
  final String username;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
    );
  }
}
