class User {
  User({
    required this.id,
    required this.username,
    this.avatarUrl,
    // set a default value if the key is not found `map` on `fromMap` or if the value is null
    this.friends = const <String, User>{},
  });

  final String id;
  final String username;
  final String? avatarUrl;
  final Map<String, User> friends;

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      username: map['username'] as String,
      avatarUrl: map['avatarUrl'] == null ? null : map['avatarUrl'] as String,
      friends: map['friends'] == null
          ? const <String, User>{}
          : <String, User>{
              for (final MapEntry<String, dynamic> e0
                  in (map['friends'] as Map<String, dynamic>).entries)
                e0.key: User.fromMap(e0.value),
            },
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'avatarUrl': avatarUrl,
      'friends': friends,
    };
  }

  @override
  int get hashCode {
    return Object.hashAll([
      id,
      username,
      avatarUrl,
      friends,
    ]);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is User &&
            id == other.id &&
            username == other.username &&
            avatarUrl == other.avatarUrl &&
            friends == other.friends;
  }

  @override
  String toString() {
    return """User(
<id= $id>,
<username= $username>,
<avatarUrl= $avatarUrl>,
<friends= $friends>,
)""";
  }
}
