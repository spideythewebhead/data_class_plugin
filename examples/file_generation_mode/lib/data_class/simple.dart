import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:file_generation_mode/pretty_print.dart';

part 'simple.gen.dart';

@DataClass()
abstract class User {
  User.ctor();

  /// Default constructor
  factory User({
    required int id,
    required String username,
    String? email,
    required bool isVerified,
  }) = _$UserImpl;

  int get id;

  String get username;

  String? get email;

  bool get isVerified;
}

void main() {
  final User user = User(
    id: 11,
    username: 'myusername',
    isVerified: true,
  );

  prettyPrint('user data class', user);
}
