import 'package:data_class_plugin/data_class_plugin.dart';

@DataClass()
class User {
  /// Shorthand constructor
  const User({
    required this.username,
    required this.id,
  });

  final String username;
  final String id;

  /// Returns a string with the properties of [User]
  @override
  String toString() {
    String value = 'User{<optimized out>}';
    assert(() {
      value = 'User@<$hexIdentity>{username: $username, id: $id}';
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
        other is User &&
            runtimeType == other.runtimeType &&
            username == other.username &&
            id == other.id;
  }

  /// Creates a new instance of [User] with optional new values
  User copyWith({
    final String? username,
    final String? id,
  }) {
    return User(
      username: username ?? this.username,
      id: id ?? this.id,
    );
  }
}
