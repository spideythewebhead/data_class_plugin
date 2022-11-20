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
  dataClass: false,
  fromJson: false,
  toJson: false,
)
class UnionWithDefaultValues {
  const factory UnionWithDefaultValues.impl({
    @UnionFieldValue<User>(User.none) User value,
    @UnionFieldValue<String>('') String value2,
    @UnionFieldValue<User>(User(username: '')) User value3,
    @UnionFieldValue<int>(0) int value4,
    @UnionFieldValue<bool>(true) bool value5,
  }) = Impl;
}
