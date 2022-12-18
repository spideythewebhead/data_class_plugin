import 'package:data_class_plugin/data_class_plugin.dart';

@Union(
  copyWith: true,
  hashAndEquals: true,
  $toString: true,
  fromJson: false,
  toJson: false,
)
abstract class User {
  const factory User.normal({
    required String id,
    required String username,
    String? email,
  }) = UserNormal;

  const factory User.admin({
    required String id,
    required String username,
    String? email,
  }) = UserAdmin;

  String get id;
  String get username;
  String? get email;
}
