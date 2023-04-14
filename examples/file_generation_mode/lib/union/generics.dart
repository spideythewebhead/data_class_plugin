import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:file_generation_mode/pretty_print.dart';

part 'generics.gen.dart';

@Union()
sealed class AsyncResult<T> {
  const AsyncResult._();

  const factory AsyncResult.loading() = AsyncResultLoading<T>;

  factory AsyncResult.data(T data) = AsyncResultData<T>;

  factory AsyncResult.error(Object error, {StackTrace? stackTrace}) = AsyncResultError<T>;
}

@DataClass()
abstract class User {
  User.ctor();

  /// Default constructor
  factory User({
    required int id,
    required String username,
  }) = _$UserImpl;

  int get id;

  String get username;
}

@Union()
sealed class UnionWithGenericConstraints<T extends User> {
  const UnionWithGenericConstraints._();

  factory UnionWithGenericConstraints.data(T data) = UnionWithGenericConstraintsData<T>;
}

@DataClass()
abstract class SuperUser extends User {
  SuperUser.ctor() : super.ctor();

  /// Default constructor
  factory SuperUser({
    required int id,
    required String username,
  }) = _$SuperUserImpl;

  @override
  int get id;

  @override
  String get username;
}

void main() {
  prettyPrint(
    'AsyncResult.data with generic type of User',
    AsyncResult<User>.data(User(id: 11, username: 'myusername')),
  );

  prettyPrint(
    'AsyncResult.data with generic type of int',
    AsyncResult<int>.data(11),
  );

  prettyPrint(
    'UnionWithGenericConstraints with generic type constraints',
    UnionWithGenericConstraints<User>.data(SuperUser(id: 11, username: 'myusername')),
  );
}
