import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:file_generation_mode/pretty_print.dart';

part 'default_value.gen.dart';

@DataClass()
abstract class User {
  User.ctor();

  /// Default constructor
  factory User({
    required int id,
    required String username,
    String email,
    bool isVerified,
  }) = _$UserImpl;

  int get id;

  String get username;

  // if no value is provided when creating an instance of a User
  // then the empty string will be used
  @DefaultValue('')
  String get email;

  // if you want to provide type safety to the passed argument
  // you can specify the type on the annotation
  @DefaultValue<bool>(false)
  bool get isVerified;
}

void main() {
  final User user1 = User(id: 11, username: 'myusername');
  final User user2 = User(
    id: 11,
    username: 'myusername',
    email: 'my@email.com',
    isVerified: true,
  );

  prettyPrint('user1 with default values', user1);
  prettyPrint('user2 with overriden default values', user2);
}
