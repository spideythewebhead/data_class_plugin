import 'dart:math';

import 'package:data_class_plugin/data_class_plugin.dart';

part 'super_class.gen.dart';

abstract class Shape {
  double area();
}

@DataClass()
abstract class Triangle extends Shape {
  Triangle.ctor();

  /// Default constructor
  factory Triangle({
    required double height,
    required double base,
  }) = _$TriangleImpl;

  double get height;
  double get base;

  @override
  double area() {
    return 0.5 * base * height;
  }
}

@DataClass()
abstract class Rectangle extends Shape {
  Rectangle.ctor();

  /// Default constructor
  factory Rectangle({
    required double width,
    required double length,
  }) = _$RectangleImpl;

  double get width;
  double get length;

  @override
  double area() {
    return width * length;
  }
}

@DataClass()
abstract class Circle extends Shape {
  Circle.ctor();

  /// Default constructor
  factory Circle({
    required double radius,
  }) = _$CircleImpl;

  double get radius;

  @override
  double area() {
    return pi * radius * radius;
  }
}

@DataClass(toJson: true)
abstract class User {
  User.ctor();

  /// Default constructor
  factory User({
    required String id,
    required String username,
    required String email,
  }) = _$UserImpl;

  String get id;
  String get username;
  String get email;

  /// Converts [User] to a [Map] json
  Map<String, dynamic> toJson();
}

@DataClass(toJson: true)
abstract class Admin extends User {
  Admin.ctor() : super.ctor();

  /// Default constructor
  factory Admin({
    required String id,
    required String username,
    required String email,
    required bool isSuperAdmin,
  }) = _$AdminImpl;

  @override
  String get id;

  @override
  String get username;

  @override
  String get email;

  bool get isSuperAdmin;

  /// Converts [Admin] to a [Map] json
  @override
  Map<String, dynamic> toJson();
}
