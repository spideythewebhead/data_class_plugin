import 'package:data_class_plugin/data_class_plugin.dart';

@DataClass(
  copyWith: true,
  fromJson: false,
  toJson: false,
  hashAndEquals: false,
  $toString: false,
)
class User {
  /// Shorthand constructor
  User({
    required this.id,
    required this.username,
    this.permissions,
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
