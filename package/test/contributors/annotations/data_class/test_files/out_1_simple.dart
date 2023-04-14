part 'in_1_simple.gen.dart';

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
