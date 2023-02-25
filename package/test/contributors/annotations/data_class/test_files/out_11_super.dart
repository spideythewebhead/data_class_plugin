@DataClass()
class AdminUser extends User {
  /// Shorthand constructor
  AdminUser({
    required super.id,
    required this.username,
  });

  final String username;

  /// Returns a string with the properties of [AdminUser]
  @override
  String toString() {
    String value = 'AdminUser{<optimized out>}';
    assert(() {
      value = 'AdminUser@<$hexIdentity>{username: $username, id: $id}';
      return true;
    }());
    return value;
  }

  /// Returns a hash code based on [this] properties
  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      username,
      id,
    ]);
  }

  /// Compares [this] with [other] on identity, class type, and properties
  /// *with deep comparison on collections*
  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is AdminUser &&
            runtimeType == other.runtimeType &&
            username == other.username &&
            id == other.id;
  }

  /// Creates a new instance of [AdminUser] with optional new values
  AdminUser copyWith({
    final String? username,
    final String? id,
  }) {
    return AdminUser(
      username: username ?? this.username,
      id: id ?? this.id,
    );
  }
}
