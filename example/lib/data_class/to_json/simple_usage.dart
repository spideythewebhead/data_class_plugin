import 'package:data_class_plugin/data_class_plugin.dart';

part 'simple_usage.gen.dart';

@DataClass(
  toJson: true,
  fromJson: false,
  copyWith: false,
  hashAndEquals: false,
  $toString: false,
)
abstract class User {
  User._();

  /// Default constructor
  factory User({
    required String id,
    required String username,
    String? email,
  }) = _$UserImpl;

  String get id;
  String get username;
  String? get email;

  /// Converts [User] to a [Map] json
  Map<String, dynamic> toJson();
}

@DataClass(
  toJson: true,
  fromJson: false,
  copyWith: false,
  hashAndEquals: false,
  $toString: false,
)
abstract class GetUsersResponse {
  GetUsersResponse._();

  /// Default constructor
  factory GetUsersResponse({
    required bool ok,
    required List<User> users,
  }) = _$GetUsersResponseImpl;

  bool get ok;
  List<User> get users;

  /// Converts [GetUsersResponse] to a [Map] json
  Map<String, dynamic> toJson();
}
