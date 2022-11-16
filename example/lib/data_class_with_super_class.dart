import 'package:data_class_plugin/data_class_plugin.dart';

class Person {
  /// Shorthand constructor
  const Person({
    required this.name,
    required this.age,
  });

  final String name;
  final String age;
}

class User extends Person {
  /// Shorthand constructor
  const User({
    required super.age,
    required super.name,
    required this.username,
    required this.id,
  });

  @JsonKey(name: '_username')
  final String username;
  final String id;
}

@DataClass()
class Admin extends User {
  /// Shorthand constructor
  const Admin({
    required super.id,
    required super.age,
    required super.name,
    required super.username,
    required this.permissions,
  });

  final List<int> permissions;

  /// Returns a string with the properties of [Admin]
  @override
  String toString() {
    return '''Admin(
  <permissions= $permissions>,
  <username= $username>,
  <id= $id>,
  <name= $name>,
  <age= $age>,
)''';
  }

  /// Returns a hash code based on [this] properties
  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      permissions,
      username,
      id,
      name,
      age,
    ]);
  }

  /// Compares [this] with [other] on identity, class type, and properties
  /// *with deep comparison on collections*
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Admin &&
            deepEquality(permissions, other.permissions) &&
            username == other.username &&
            id == other.id &&
            name == other.name &&
            age == other.age;
  }

  /// Creates a new instance of [Admin] with optional new values
  Admin copyWith({
    final List<int>? permissions,
    final String? username,
    final String? id,
    final String? name,
    final String? age,
  }) {
    return Admin(
      permissions: permissions ?? this.permissions,
      username: username ?? this.username,
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }
}
