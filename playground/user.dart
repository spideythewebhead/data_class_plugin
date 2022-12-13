import 'package:data_class_plugin/data_class_plugin.dart';

part 'user.gen.dart';

@DataClass(
  fromJson: true,
  toJson: true,
)
abstract class User {
  const User._();

  /// Default constructor
  const factory User({
    required String username,
  }) = _$UserImpl;

  @JsonKey(name: '_uname')
  String get username;

  /// Creates a new instance of [User] with optional new values
  User copyWith({
    final String? username,
  });

  /// Returns a hash code based on [this] properties
  @override
  int get hashCode;

  /// Compares [this] with [other] on identity, class type, and properties
  /// *with deep comparison on collections*
  @override
  bool operator ==(Object? other);

  @override
  String toString();

  /// Creates an instance of [User] from [json]
  factory User.fromJson(Map<dynamic, dynamic> json) = _$UserImpl.fromJson;

  /// Converts [User] to a [Map] json
  Map<String, dynamic> toJson();
}
