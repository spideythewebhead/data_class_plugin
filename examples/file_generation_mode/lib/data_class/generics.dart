import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:file_generation_mode/pretty_print.dart';

part 'generics.gen.dart';

@DataClass()
abstract class ValueWrapper<T> {
  ValueWrapper.ctor();

  /// Default constructor
  factory ValueWrapper({
    required T value,
  }) = _$ValueWrapperImpl<T>;

  T get value;
}

@DataClass()
abstract class User {
  User.ctor();

  /// Default constructor
  factory User({
    required int id,
  }) = _$UserImpl;

  int get id;
}

@DataClass()
abstract class ValueWrapperWithGenericsConstraints<T extends User> {
  ValueWrapperWithGenericsConstraints.ctor();

  /// Default constructor
  factory ValueWrapperWithGenericsConstraints({
    required T value,
  }) = _$ValueWrapperWithGenericsConstraintsImpl<T>;

  T get value;
}

@DataClass()
abstract class SuperUser extends User {
  SuperUser.ctor() : super.ctor();

  /// Default constructor
  factory SuperUser({
    required int id,
  }) = _$SuperUserImpl;

  @override
  int get id;
}

void main() {
  final ValueWrapper<int> intValueWrapper = ValueWrapper<int>(value: 5);
  final ValueWrapper<User> userValueWrapper = ValueWrapper<User>(value: User(id: 11));

  prettyPrint('int value wrapper', intValueWrapper);
  prettyPrint('user value wrapper', userValueWrapper);

  final ValueWrapperWithGenericsConstraints<User> userValueWrapperWithGenericTypeConstraints =
      ValueWrapperWithGenericsConstraints<User>(value: SuperUser(id: 11));

  prettyPrint(
    'super user value wrapper with type constraints',
    userValueWrapperWithGenericTypeConstraints,
  );
}
