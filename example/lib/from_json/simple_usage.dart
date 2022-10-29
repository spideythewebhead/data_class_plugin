class User {
  /// Shorthand constructor
  User({
    required this.id,
    required this.username,
  });

  final String id;
  final String username;

  /// Creates an instance of [User] from [json]
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
    );
  }
}
