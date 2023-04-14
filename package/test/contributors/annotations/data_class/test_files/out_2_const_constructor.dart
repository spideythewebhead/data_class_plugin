part 'in_2_const_constructor.gen.dart';

@DataClass()
abstract class User {
  const User.ctor();

  /// Default constructor
  const factory User({
    required int id,
    required String username,
  }) = _$UserImpl;

  int get id;

  String get username;
}
