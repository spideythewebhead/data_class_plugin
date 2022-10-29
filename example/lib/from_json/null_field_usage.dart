class User {
  User({
    this.avatarUrl, // = add a default value if you want to handle null
  });

  final String? avatarUrl;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      avatarUrl: json['avatarUrl'] == null ? null : json['avatarUrl'] as String,
    );
  }
}
