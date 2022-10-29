class User {
  User({
    // set a default value if the key is not found `json` on `fromJson` or if the value is null
    this.friends = const <String, User>{},
  });

  final Map<String, User> friends;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      friends: json['friends'] == null
          ? const <String, User>{}
          : <String, User>{
              for (final MapEntry<String, dynamic> e0 in (json['friends'] as Map<String, dynamic>).entries) e0.key: User.fromJson(e0.value),
            },
    );
  }
}
