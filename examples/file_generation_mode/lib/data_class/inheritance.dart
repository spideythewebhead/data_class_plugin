import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:file_generation_mode/pretty_print.dart';

part 'inheritance.gen.dart';

// Inherit from normal class

abstract class Shape {
  double get area;
}

@DataClass()
abstract class Rectangle extends Shape {
  Rectangle.ctor();

  /// Default constructor
  factory Rectangle() = _$RectangleImpl;

  @override
  double get area => 0;
}

// Inherit from data class

@DataClass()
abstract class User {
  User.ctor();

  /// Default constructor
  factory User({
    required int id,
    required String username,
  }) = _$UserImpl;

  int get id;

  String get username;
}

@DataClass()
abstract class SuperUser extends User {
  SuperUser.ctor() : super.ctor();

  /// Default constructor
  factory SuperUser({
    required int id,
    required String username,
    required String nickname,
    required bool isEnabled,
  }) = _$SuperUserImpl;

  @override
  int get id;

  @override
  String get username;

  String get nickname;

  bool get isEnabled;
}

void main() {
  final User user = User(id: 11, username: 'myusername');
  final SuperUser superUser = SuperUser(
    id: 11,
    username: 'myusername',
    nickname: 'mynickname',
    isEnabled: true,
  );

  prettyPrint('user', user);
  prettyPrint('super user', superUser);
}
