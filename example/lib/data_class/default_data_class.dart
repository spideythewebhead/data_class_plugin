import 'package:data_class_plugin/data_class_plugin.dart';

part 'default_data_class.gen.dart';

@DataClass()
abstract class User {
  const User._();

  /// Default constructor
  const factory User({
    required String username,
    required String id,
  }) = _$UserImpl;

  String get username;
  String get id;

  @override
  String toString();

  /// Returns a hash code based on [this] properties
  @override
  int get hashCode;

  /// Compares [this] with [other] on identity, class type, and properties
  /// *with deep comparison on collections*
  @override
  bool operator ==(Object? other);

  /// Creates a new instance of [User] with optional new values
  User copyWith({
    final String? username,
    final String? id,
  });
}
