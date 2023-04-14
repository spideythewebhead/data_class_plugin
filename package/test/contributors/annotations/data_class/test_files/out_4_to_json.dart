part 'in_4_to_json.gen.dart';

@DataClass(
  toJson: true,
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

  /// Converts [User] to a [Map] json
  Map<String, dynamic> toJson();
}
