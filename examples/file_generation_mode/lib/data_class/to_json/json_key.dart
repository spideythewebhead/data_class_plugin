import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:file_generation_mode/pretty_print.dart';

part 'json_key.gen.dart';

@DataClass(
  toJson: true,
)
abstract class User {
  User.ctor();

  /// Default constructor
  factory User({
    required int id,
    required String username,
    required bool isVerified,
  }) = _$UserImpl;

  // Custom json key name
  @JsonKey(name: '_id')
  int get id;

  // Custom from json method
  @JsonKey<String>(toJson: User._customUsernameToJson)
  String get username;

  // This can be a static method or a top level function
  static String _customUsernameToJson(String value) {
    return '_$value';
  }

  // Specific name convention for field name
  @JsonKey(nameConvention: JsonKeyNameConvention.kebabCase)
  bool get isVerified;

  /// Converts [User] to a [Map] json
  Map<String, dynamic> toJson();
}

void main(List<String> args) {
  final User user = User(
    id: 11,
    username: 'myusername',
    isVerified: true,
  );

  prettyPrint('user toJson', user.toJson());
}
