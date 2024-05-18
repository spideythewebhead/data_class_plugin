// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
// coverage:ignore-file

part of 'generics.dart';

class _$ValueWrapperImpl<T> extends ValueWrapper<T> {
  _$ValueWrapperImpl({
    required this.value,
  }) : super.ctor();

  @override
  final T value;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ValueWrapper<T> && runtimeType == other.runtimeType && value == other.value;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      value,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'ValueWrapper{<optimized out>}';
    assert(() {
      toStringOutput = 'ValueWrapper@<$hexIdentity>{value: $value}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => ValueWrapper<T>;
}

abstract interface class _ValueWrapperCopyWithProxy<T> {
  ValueWrapper<T> value(T newValue);

  ValueWrapper<T> call({
    final T? value,
  });
}

class _ValueWrapperCopyWithProxyImpl<T> implements _ValueWrapperCopyWithProxy<T> {
  _ValueWrapperCopyWithProxyImpl(this._value);

  final ValueWrapper<T> _value;

  @pragma('vm:prefer-inline')
  @override
  ValueWrapper<T> value(T newValue) => this(value: newValue);

  @pragma('vm:prefer-inline')
  @override
  ValueWrapper<T> call({
    final T? value,
  }) {
    return _$ValueWrapperImpl<T>(
      value: value ?? _value.value,
    );
  }
}

sealed class $ValueWrapperCopyWithProxyChain<T, $Result> {
  factory $ValueWrapperCopyWithProxyChain(
          final ValueWrapper<T> value, final $Result Function(ValueWrapper<T> update) chain) =
      _ValueWrapperCopyWithProxyChainImpl<T, $Result>;

  $Result value(T newValue);

  $Result call({
    final T? value,
  });
}

class _ValueWrapperCopyWithProxyChainImpl<T, $Result>
    implements $ValueWrapperCopyWithProxyChain<T, $Result> {
  _ValueWrapperCopyWithProxyChainImpl(this._value, this._chain);

  final ValueWrapper<T> _value;
  final $Result Function(ValueWrapper<T> update) _chain;

  @pragma('vm:prefer-inline')
  @override
  $Result value(T newValue) => this(value: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result call({
    final T? value,
  }) {
    return _chain(_$ValueWrapperImpl<T>(
      value: value ?? _value.value,
    ));
  }
}

extension $ValueWrapperExtension<T> on ValueWrapper<T> {
  _ValueWrapperCopyWithProxy<T> get copyWith => _ValueWrapperCopyWithProxyImpl<T>(this);
}

class _$UserImpl extends User {
  _$UserImpl({
    required this.id,
  }) : super.ctor();

  @override
  final int id;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is User && runtimeType == other.runtimeType && id == other.id;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      id,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'User{<optimized out>}';
    assert(() {
      toStringOutput = 'User@<$hexIdentity>{id: $id}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => User;
}

abstract interface class _UserCopyWithProxy {
  User id(int newValue);

  User call({
    final int? id,
  });
}

class _UserCopyWithProxyImpl implements _UserCopyWithProxy {
  _UserCopyWithProxyImpl(this._value);

  final User _value;

  @pragma('vm:prefer-inline')
  @override
  User id(int newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  @override
  User call({
    final int? id,
  }) {
    return _$UserImpl(
      id: id ?? _value.id,
    );
  }
}

sealed class $UserCopyWithProxyChain<$Result> {
  factory $UserCopyWithProxyChain(final User value, final $Result Function(User update) chain) =
      _UserCopyWithProxyChainImpl<$Result>;

  $Result id(int newValue);

  $Result call({
    final int? id,
  });
}

class _UserCopyWithProxyChainImpl<$Result> implements $UserCopyWithProxyChain<$Result> {
  _UserCopyWithProxyChainImpl(this._value, this._chain);

  final User _value;
  final $Result Function(User update) _chain;

  @pragma('vm:prefer-inline')
  @override
  $Result id(int newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result call({
    final int? id,
  }) {
    return _chain(_$UserImpl(
      id: id ?? _value.id,
    ));
  }
}

extension $UserExtension on User {
  _UserCopyWithProxy get copyWith => _UserCopyWithProxyImpl(this);
}

class _$ValueWrapperWithGenericsConstraintsImpl<T extends User>
    extends ValueWrapperWithGenericsConstraints<T> {
  _$ValueWrapperWithGenericsConstraintsImpl({
    required this.value,
  }) : super.ctor();

  @override
  final T value;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ValueWrapperWithGenericsConstraints<T> &&
            runtimeType == other.runtimeType &&
            value == other.value;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      value,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'ValueWrapperWithGenericsConstraints{<optimized out>}';
    assert(() {
      toStringOutput = 'ValueWrapperWithGenericsConstraints@<$hexIdentity>{value: $value}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => ValueWrapperWithGenericsConstraints<T>;
}

abstract interface class _ValueWrapperWithGenericsConstraintsCopyWithProxy<T extends User> {
  ValueWrapperWithGenericsConstraints<T> value(T newValue);

  ValueWrapperWithGenericsConstraints<T> call({
    final T? value,
  });
}

class _ValueWrapperWithGenericsConstraintsCopyWithProxyImpl<T extends User>
    implements _ValueWrapperWithGenericsConstraintsCopyWithProxy<T> {
  _ValueWrapperWithGenericsConstraintsCopyWithProxyImpl(this._value);

  final ValueWrapperWithGenericsConstraints<T> _value;

  @pragma('vm:prefer-inline')
  @override
  ValueWrapperWithGenericsConstraints<T> value(T newValue) => this(value: newValue);

  @pragma('vm:prefer-inline')
  @override
  ValueWrapperWithGenericsConstraints<T> call({
    final T? value,
  }) {
    return _$ValueWrapperWithGenericsConstraintsImpl<T>(
      value: value ?? _value.value,
    );
  }
}

sealed class $ValueWrapperWithGenericsConstraintsCopyWithProxyChain<T extends User, $Result> {
  factory $ValueWrapperWithGenericsConstraintsCopyWithProxyChain(
          final ValueWrapperWithGenericsConstraints<T> value,
          final $Result Function(ValueWrapperWithGenericsConstraints<T> update) chain) =
      _ValueWrapperWithGenericsConstraintsCopyWithProxyChainImpl<T, $Result>;

  $Result value(T newValue);

  $Result call({
    final T? value,
  });
}

class _ValueWrapperWithGenericsConstraintsCopyWithProxyChainImpl<T extends User, $Result>
    implements $ValueWrapperWithGenericsConstraintsCopyWithProxyChain<T, $Result> {
  _ValueWrapperWithGenericsConstraintsCopyWithProxyChainImpl(this._value, this._chain);

  final ValueWrapperWithGenericsConstraints<T> _value;
  final $Result Function(ValueWrapperWithGenericsConstraints<T> update) _chain;

  @pragma('vm:prefer-inline')
  @override
  $Result value(T newValue) => this(value: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result call({
    final T? value,
  }) {
    return _chain(_$ValueWrapperWithGenericsConstraintsImpl<T>(
      value: value ?? _value.value,
    ));
  }
}

extension $ValueWrapperWithGenericsConstraintsExtension<T extends User>
    on ValueWrapperWithGenericsConstraints<T> {
  _ValueWrapperWithGenericsConstraintsCopyWithProxy<T> get copyWith =>
      _ValueWrapperWithGenericsConstraintsCopyWithProxyImpl<T>(this);
}

class _$SuperUserImpl extends SuperUser {
  _$SuperUserImpl({
    required this.id,
  }) : super.ctor();

  @override
  final int id;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SuperUser && runtimeType == other.runtimeType && id == other.id;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      id,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'SuperUser{<optimized out>}';
    assert(() {
      toStringOutput = 'SuperUser@<$hexIdentity>{id: $id}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => SuperUser;
}

abstract interface class _SuperUserCopyWithProxy {
  SuperUser id(int newValue);

  SuperUser call({
    final int? id,
  });
}

class _SuperUserCopyWithProxyImpl implements _SuperUserCopyWithProxy {
  _SuperUserCopyWithProxyImpl(this._value);

  final SuperUser _value;

  @pragma('vm:prefer-inline')
  @override
  SuperUser id(int newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  @override
  SuperUser call({
    final int? id,
  }) {
    return _$SuperUserImpl(
      id: id ?? _value.id,
    );
  }
}

sealed class $SuperUserCopyWithProxyChain<$Result> {
  factory $SuperUserCopyWithProxyChain(
          final SuperUser value, final $Result Function(SuperUser update) chain) =
      _SuperUserCopyWithProxyChainImpl<$Result>;

  $Result id(int newValue);

  $Result call({
    final int? id,
  });
}

class _SuperUserCopyWithProxyChainImpl<$Result> implements $SuperUserCopyWithProxyChain<$Result> {
  _SuperUserCopyWithProxyChainImpl(this._value, this._chain);

  final SuperUser _value;
  final $Result Function(SuperUser update) _chain;

  @pragma('vm:prefer-inline')
  @override
  $Result id(int newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result call({
    final int? id,
  }) {
    return _chain(_$SuperUserImpl(
      id: id ?? _value.id,
    ));
  }
}

extension $SuperUserExtension on SuperUser {
  _SuperUserCopyWithProxy get copyWith => _SuperUserCopyWithProxyImpl(this);
}
