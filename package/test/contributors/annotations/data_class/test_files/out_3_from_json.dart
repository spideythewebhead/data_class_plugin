part 'in_3_from_json.gen.dart';

@DataClass(
  fromJson: true,
)
abstract class User {
  User.ctor();

  /// Default constructor
  factory User({
    required int id,
    required String username,
  }) = _$UserImpl;

  int get id;

  String get username;

  /// Creates an instance of [User] from [json]
  factory User.fromJson(Map<dynamic, dynamic> json) = _$UserImpl.fromJson;
}
