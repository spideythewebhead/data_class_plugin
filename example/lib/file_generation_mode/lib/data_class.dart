import 'package:data_class_plugin/data_class_plugin.dart';

part 'data_class.gen.dart';

@DataClass(
  fromJson: true,
  toJson: true,
)
abstract class User {
  User._();

  /// Default constructor
  factory User({
    required String id,
    required String username,
    String email,
  }) = _$UserImpl;

  String get id;
  String get username;

  @DefaultValue('')
  String get email;

  /// Creates an instance of [User] from [json]
  factory User.fromJson(Map<dynamic, dynamic> json) = _$UserImpl.fromJson;

  /// Creates a new instance of [User] with optional new values
  User copyWith({
    final String? id,
    final String? username,
    final String? email,
  });

  /// Converts [User] to a [Map] json
  Map<String, dynamic> toJson();
}
