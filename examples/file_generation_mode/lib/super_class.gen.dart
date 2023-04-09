// AUTO GENERATED - DO NOT MODIFY

// ignore_for_file: library_private_types_in_public_api, unused_element, unused_field

part of 'super_class.dart';

class _$TriangleImpl extends Triangle {
  _$TriangleImpl({
    required this.height,
    required this.base,
  }) : super.ctor();

  @override
  final double height;

  @override
  final double base;

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is Triangle &&
            runtimeType == other.runtimeType &&
            height == other.height &&
            base == other.base;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      height,
      base,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'Triangle{<optimized out>}';
    assert(() {
      toStringOutput = 'Triangle@<$hexIdentity>{height: $height, base: $base}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => Triangle;
}

class _$RectangleImpl extends Rectangle {
  _$RectangleImpl({
    required this.width,
    required this.length,
  }) : super.ctor();

  @override
  final double width;

  @override
  final double length;

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is Rectangle &&
            runtimeType == other.runtimeType &&
            width == other.width &&
            length == other.length;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      width,
      length,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'Rectangle{<optimized out>}';
    assert(() {
      toStringOutput = 'Rectangle@<$hexIdentity>{width: $width, length: $length}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => Rectangle;
}

class _$CircleImpl extends Circle {
  _$CircleImpl({
    required this.radius,
  }) : super.ctor();

  @override
  final double radius;

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is Circle && runtimeType == other.runtimeType && radius == other.radius;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      radius,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'Circle{<optimized out>}';
    assert(() {
      toStringOutput = 'Circle@<$hexIdentity>{radius: $radius}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => Circle;
}

class _$UserImpl extends User {
  _$UserImpl({
    required this.id,
    required this.username,
    required this.email,
  }) : super.ctor();

  @override
  final String id;

  @override
  final String username;

  @override
  final String email;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
    };
  }

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is User &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            username == other.username &&
            email == other.email;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      id,
      username,
      email,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'User{<optimized out>}';
    assert(() {
      toStringOutput = 'User@<$hexIdentity>{id: $id, username: $username, email: $email}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => User;
}

class _$AdminImpl extends Admin {
  _$AdminImpl({
    required this.id,
    required this.username,
    required this.email,
    required this.isSuperAdmin,
  }) : super.ctor();

  @override
  final String id;

  @override
  final String username;

  @override
  final String email;

  @override
  final bool isSuperAdmin;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'isSuperAdmin': isSuperAdmin,
    };
  }

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is Admin &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            username == other.username &&
            email == other.email &&
            isSuperAdmin == other.isSuperAdmin;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      id,
      username,
      email,
      isSuperAdmin,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'Admin{<optimized out>}';
    assert(() {
      toStringOutput =
          'Admin@<$hexIdentity>{id: $id, username: $username, email: $email, isSuperAdmin: $isSuperAdmin}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => Admin;
}
