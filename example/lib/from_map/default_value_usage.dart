class User {
  User({
    // set a default value if the key is not found `map` on `fromMap` or if the value is null
    this.friends = const <String, User>{},
  });

  final Map<String, User> friends;

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      friends: map['friends'] == null
          ? const <String, User>{}
          : <String, User>{
              for (final MapEntry<String, dynamic> e0
                  in (map['friends'] as Map<String, dynamic>).entries)
                e0.key: User.fromMap(e0.value),
            },
    );
  }
}
