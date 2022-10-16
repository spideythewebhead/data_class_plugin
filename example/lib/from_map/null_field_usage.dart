class User {
  User({
    this.avatarUrl, // = add a default value if you want to handle null
  });

  final String? avatarUrl;

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      avatarUrl: map['avatarUrl'] == null ? null : map['avatarUrl'] as String,
    );
  }
}
