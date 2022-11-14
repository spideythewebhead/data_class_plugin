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
  const UnionWithDefaultValues._();

  const factory UnionWithDefaultValues.impl({
    @UnionFieldValue<User>(User.none) User value,
    @UnionFieldValue<String>('') String value2,
    @UnionFieldValue<User>(User(username: '')) User value3,
    @UnionFieldValue<int>(0) int value4,
    @UnionFieldValue<bool>(true) bool value5,
  }) = Impl;

  /// Executes one of the provided callbacks based on a type match
  R when<R>({
    required R Function(Impl value) impl,
  }) {
    if (this is Impl) {
      return impl(this as Impl);
    }
    throw UnimplementedError('Unknown instance of $this used in when(..)');
  }

  /// Executes one of the provided callbacks if a type is matched
  ///
  /// If no match is found [orElse] is executed
  R maybeWhen<R>({
    R Function(Impl value)? impl,
    required R Function() orElse,
  }) {
    if (this is Impl) {
      return impl?.call(this as Impl) ?? orElse();
    }
    throw UnimplementedError('Unknown instance of $this used in maybeWhen(..)');
  }
}

class Impl extends UnionWithDefaultValues {
  const Impl({
    this.value = User.none,
    this.value2 = '',
    this.value3 = const User(username: ''),
    this.value4 = 0,
    this.value5 = true,
  }) : super._();

  final User value;
  final String value2;
  final User value3;
  final int value4;
  final bool value5;
}
