import 'package:data_class_plugin/data_class_plugin.dart';

@DataClass()
abstract class User {
  User.ctor();

  /// Default constructor
  const factory User({
    required int id,
    required String username,
  }) = _$UserImpl;

  int get id;

  String get username;
}
