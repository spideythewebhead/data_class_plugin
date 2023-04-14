part 'in_6_convert_final_fields_to_getters.gen.dart';

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
