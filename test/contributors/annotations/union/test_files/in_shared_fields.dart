import 'package:data_class_plugin/data_class_plugin.dart';

@Union(
  dataClass: true,
  fromJson: false,
  toJson: false,
)
abstract class User {
  const User._();

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
