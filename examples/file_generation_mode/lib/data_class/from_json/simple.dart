import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:file_generation_mode/pretty_print.dart';

part 'simple.gen.dart';

@DataClass(
  // this option is set to false by default
  // you can override this explicitly for each annotated class or
  // use data_class_plugin_options.yaml to specify target paths
  fromJson: true,
)
abstract class User {
  User.ctor();

  /// Default constructor
  factory User({
    required int id,
    required String username,
    String? email,
    required bool isVerified,
  }) = _$UserImpl;

  /// Creates an instance of [User] from [json]
  factory User.fromJson(Map<dynamic, dynamic> json) = _$UserImpl.fromJson;

  int get id;

  String get username;

  String? get email;

  bool get isVerified;
}

@DataClass()
abstract class GetUsersResult {
  GetUsersResult.ctor();

  /// Default constructor
  factory GetUsersResult({
    required List<User> users,
  }) = _$GetUsersResultImpl;

  /// Creates an instance of [GetUsersResult] from [json]
  factory GetUsersResult.fromJson(Map<dynamic, dynamic> json) = _$GetUsersResultImpl.fromJson;

  List<User> get users;
}

void main(List<String> args) {
  final User user = User.fromJson(<String, dynamic>{
    'id': 11,
    'username': 'myusername',
    'email': 'email@email.com',
    'isVerified': true,
  });

  prettyPrint('user fromJson', user);

  final GetUsersResult getUsersResult = GetUsersResult.fromJson(<String, dynamic>{
    'users': <Map<String, dynamic>>[
      <String, dynamic>{
        'id': 11,
        'username': 'myusername',
        'email': 'email@email.com',
        'isVerified': true,
      },
      <String, dynamic>{
        'id': 12,
        'username': 'myusername',
        'email': 'email@email.com',
        'isVerified': false,
      },
    ],
  });

  prettyPrint('getUsersResult fromJson (list of User)', getUsersResult);
}
