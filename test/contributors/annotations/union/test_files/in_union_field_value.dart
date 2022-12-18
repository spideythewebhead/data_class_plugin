import 'package:data_class_plugin/data_class_plugin.dart';

class User {
  /// Shorthand constructor
  const User({
    required this.username,
  });

  final String username;

  static const none = User(username: '');
}

@Union(
  hashAndEquals: false,
  $toString: false,
  fromJson: false,
  toJson: false,
)
class UnionWithDefaultValues {
  const factory UnionWithDefaultValues.impl({
    @DefaultValue<User>(User.none) User value,
    @DefaultValue<String>('') String value2,
    @DefaultValue<User>(User(username: '')) User value3,
    @DefaultValue<int>(0) int value4,
    @DefaultValue<bool>(true) bool value5,
  }) = Impl;
}
