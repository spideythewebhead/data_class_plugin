import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:file_generation_mode/pretty_print.dart';

part 'simple.gen.dart';

@DataClass(
  // this option is set to false by default
  // you can override this explicitly for each annotated class or
  // use data_class_plugin_options.yaml to specify target paths
  toJson: true,
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

  int get id;

  String get username;

  String? get email;

  bool get isVerified;

  /// Converts [User] to a [Map] json
  Map<String, dynamic> toJson();
}

@DataClass()
abstract class GetUsersResult {
  GetUsersResult.ctor();

  /// Default constructor
  factory GetUsersResult({
    required List<User> users,
  }) = _$GetUsersResultImpl;

  List<User> get users;

  /// Converts [GetUsersResult] to a [Map] json
  Map<String, dynamic> toJson();
}

void main(List<String> args) {
  final User user = User(
    id: 11,
    username: 'myusername',
    email: 'email@email.com',
    isVerified: true,
  );

  prettyPrint('user toJson', user.toJson());

  final GetUsersResult getUsersResult = GetUsersResult(
    users: <User>[
      user,
      user.copyWith(id: 12, isVerified: false),
    ],
  );

  prettyPrint('getUsersResult toJson (list of User)', getUsersResult.toJson());
}
