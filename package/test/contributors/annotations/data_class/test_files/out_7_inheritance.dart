part 'in_7_inheritance.gen.dart';

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
  }) = _$SuperUserImpl;

  @override
  int get id;

  @override
  String get username;
}
