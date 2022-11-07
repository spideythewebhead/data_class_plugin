class User {
  User({
    required this.id,
    required this.username,
    required this.permissions,
  });

  final String id;
  final String username;
  final List<int>? permissions;

  /// Creates a new instance of [User] with optional new values
  User copyWith({
    final String? id,
    final String? username,
    final List<int>? permissions,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      permissions: permissions ?? this.permissions,
    );
  }
}
