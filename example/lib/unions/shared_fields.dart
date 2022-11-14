import 'package:data_class_plugin/data_class_plugin.dart';

@Union(
  dataClass: true,
  fromJson: false,
  toJson: false,
)
abstract class User {
  const User._();

  const factory User.normal({
    required String id,
    required String username,
    String? email,
  }) = UserNormal;

  const factory User.admin({
    required String id,
    required String username,
    String? email,
  }) = UserAdmin;

  String get id;
  String get username;
  String? get email;

  /// Executes one of the provided callbacks based on a type match
  R when<R>({
    required R Function(UserNormal value) normal,
    required R Function(UserAdmin value) admin,
  }) {
    if (this is UserNormal) {
      return normal(this as UserNormal);
    }
    if (this is UserAdmin) {
      return admin(this as UserAdmin);
    }
    throw UnimplementedError('Unknown instance of $this used in when(..)');
  }

  /// Executes one of the provided callbacks if a type is matched
  ///
  /// If no match is found [orElse] is executed
  R maybeWhen<R>({
    R Function(UserNormal value)? normal,
    R Function(UserAdmin value)? admin,
    required R Function() orElse,
  }) {
    if (this is UserNormal) {
      return normal?.call(this as UserNormal) ?? orElse();
    }
    if (this is UserAdmin) {
      return admin?.call(this as UserAdmin) ?? orElse();
    }
    throw UnimplementedError('Unknown instance of $this used in maybeWhen(..)');
  }
}

class UserNormal extends User {
  const UserNormal({
    required this.id,
    required this.username,
    this.email,
  }) : super._();

  @override
  final String id;
  @override
  final String username;
  @override
  final String? email;

  /// Creates a new instance of [UserNormal] with optional new values
  UserNormal copyWith({
    final String? id,
    final String? username,
    final String? email,
  }) {
    return UserNormal(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }

  /// Returns a hash code based on [this] properties
  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      id,
      username,
      email,
    ]);
  }

  /// Compares [this] with [other] on identity, class type, and properties
  /// *with deep comparison on collections*
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UserNormal && id == other.id && username == other.username && email == other.email;
  }

  /// Returns a string with the properties of [UserNormal]
  @override
  String toString() {
    return '''UserNormal(
  <id= $id>,
  <username= $username>,
  <email= $email>,
)''';
  }
}

class UserAdmin extends User {
  const UserAdmin({
    required this.id,
    required this.username,
    this.email,
  }) : super._();

  @override
  final String id;
  @override
  final String username;
  @override
  final String? email;

  /// Creates a new instance of [UserAdmin] with optional new values
  UserAdmin copyWith({
    final String? id,
    final String? username,
    final String? email,
  }) {
    return UserAdmin(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }

  /// Returns a hash code based on [this] properties
  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      id,
      username,
      email,
    ]);
  }

  /// Compares [this] with [other] on identity, class type, and properties
  /// *with deep comparison on collections*
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UserAdmin && id == other.id && username == other.username && email == other.email;
  }

  /// Returns a string with the properties of [UserAdmin]
  @override
  String toString() {
    return '''UserAdmin(
  <id= $id>,
  <username= $username>,
  <email= $email>,
)''';
  }
}
