part 'in_5_default_value.gen.dart';

@DataClass()
abstract class User {
  User.ctor();

  /// Default constructor
  factory User({
    required int id,
    required String username,
    String email,
  }) = _$UserImpl;

  int get id;

  String get username;

  @DefaultValue('')
  String get email;
}
