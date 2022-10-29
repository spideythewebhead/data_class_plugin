class User {
  /// Shorthand constructor
  User({
    this.avatarUrl,
  });

  final String? avatarUrl;

  /// Creates an instance of [User] from [json]
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      avatarUrl: json['avatarUrl'] == null ? null : json['avatarUrl'] as String,
    );
  }
}
