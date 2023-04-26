import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:file_generation_mode/pretty_print.dart';

part 'json_key.gen.dart';

@DataClass(
  fromJson: true,
)
abstract class User {
  User.ctor();

  /// Default constructor
  factory User({
    required int id,
    required String username,
    required bool isVerified,
  }) = _$UserImpl;

  /// Creates an instance of [User] from [json]
  factory User.fromJson(Map<dynamic, dynamic> json) = _$UserImpl.fromJson;

  // Custom json key name
  @JsonKey(name: '_id')
  int get id;

  // Custom from json method
  @JsonKey<String>(fromJson: User._customUsernameFromJson)
  String get username;

  // This can be a static method or a top level function
  static String _customUsernameFromJson(
    dynamic value,
    Map<dynamic, dynamic> json,
    String jsonKey,
  ) {
    if (value is String) {
      return value;
    }
    return (json['fallbackUsername'] as String?) ?? '';
  }

  // Specific name convention for field name
  @JsonKey(nameConvention: JsonKeyNameConvention.kebabCase)
  bool get isVerified;
}

void main(List<String> args) {
  final User user1 = User.fromJson(<String, dynamic>{
    '_id': 11,
    'username': 'myusername',
    'is-verified': true,
  });

  final User user2 = User.fromJson(<String, dynamic>{
    '_id': 11,
    'fallbackUsername': 'fallbackUsername',
    'is-verified': false,
  });

  prettyPrint('user1 fromJson', user1);
  prettyPrint('user2 fromJson', user2);
}
