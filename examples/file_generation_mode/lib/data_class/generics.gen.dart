// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
// coverage:ignore-file

part of 'generics.dart';

class _$ValueWrapperImpl<T> extends ValueWrapper<T> {
  _$ValueWrapperImpl({
    required this.value,
  }) : super.ctor();

  @override
  final T value;

  @override
  bool operator ==(Object? other) {
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

class _$ValueWrapperCopyWithProxy<T> {
  _$ValueWrapperCopyWithProxy(this._value);

  final ValueWrapper<T> _value;

  @pragma('vm:prefer-inline')
  ValueWrapper<T> value(T newValue) => this(value: newValue);

  @pragma('vm:prefer-inline')
  ValueWrapper<T> call({
    final T? value,
  }) {
    return _$ValueWrapperImpl<T>(
      value: value ?? _value.value,
    );
  }
}

class $ValueWrapperCopyWithProxyChain<T, $Result> {
  $ValueWrapperCopyWithProxyChain(this._value, this._chain);

  final ValueWrapper<T> _value;
  final $Result Function(ValueWrapper<T> update) _chain;

  @pragma('vm:prefer-inline')
  $Result value(T newValue) => this(value: newValue);

  @pragma('vm:prefer-inline')
  $Result call({
    final T? value,
  }) {
    return _chain(_$ValueWrapperImpl<T>(
      value: value ?? _value.value,
    ));
  }
}

extension $ValueWrapperExtension<T> on ValueWrapper<T> {
  _$ValueWrapperCopyWithProxy<T> get copyWith => _$ValueWrapperCopyWithProxy<T>(this);
}

class _$UserImpl extends User {
  _$UserImpl({
    required this.id,
  }) : super.ctor();

  @override
  final int id;

  @override
  bool operator ==(Object? other) {
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

class _$UserCopyWithProxy {
  _$UserCopyWithProxy(this._value);

  final User _value;

  @pragma('vm:prefer-inline')
  User id(int newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  User call({
    final int? id,
  }) {
    return _$UserImpl(
      id: id ?? _value.id,
    );
  }
}

class $UserCopyWithProxyChain<$Result> {
  $UserCopyWithProxyChain(this._value, this._chain);

  final User _value;
  final $Result Function(User update) _chain;

  @pragma('vm:prefer-inline')
  $Result id(int newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  $Result call({
    final int? id,
  }) {
    return _chain(_$UserImpl(
      id: id ?? _value.id,
    ));
  }
}

extension $UserExtension on User {
  _$UserCopyWithProxy get copyWith => _$UserCopyWithProxy(this);
}

class _$ValueWrapperWithGenericsConstraintsImpl<T extends User>
    extends ValueWrapperWithGenericsConstraints<T> {
  _$ValueWrapperWithGenericsConstraintsImpl({
    required this.value,
  }) : super.ctor();

  @override
  final T value;

  @override
  bool operator ==(Object? other) {
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

class _$ValueWrapperWithGenericsConstraintsCopyWithProxy<T extends User> {
  _$ValueWrapperWithGenericsConstraintsCopyWithProxy(this._value);

  final ValueWrapperWithGenericsConstraints<T> _value;

  @pragma('vm:prefer-inline')
  ValueWrapperWithGenericsConstraints<T> value(T newValue) => this(value: newValue);

  @pragma('vm:prefer-inline')
  ValueWrapperWithGenericsConstraints<T> call({
    final T? value,
  }) {
    return _$ValueWrapperWithGenericsConstraintsImpl<T>(
      value: value ?? _value.value,
    );
  }
}

class $ValueWrapperWithGenericsConstraintsCopyWithProxyChain<T extends User, $Result> {
  $ValueWrapperWithGenericsConstraintsCopyWithProxyChain(this._value, this._chain);

  final ValueWrapperWithGenericsConstraints<T> _value;
  final $Result Function(ValueWrapperWithGenericsConstraints<T> update) _chain;

  @pragma('vm:prefer-inline')
  $Result value(T newValue) => this(value: newValue);

  @pragma('vm:prefer-inline')
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
  _$ValueWrapperWithGenericsConstraintsCopyWithProxy<T> get copyWith =>
      _$ValueWrapperWithGenericsConstraintsCopyWithProxy<T>(this);
}

class _$SuperUserImpl extends SuperUser {
  _$SuperUserImpl({
    required this.id,
  }) : super.ctor();

  @override
  final int id;

  @override
  bool operator ==(Object? other) {
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

class _$SuperUserCopyWithProxy {
  _$SuperUserCopyWithProxy(this._value);

  final SuperUser _value;

  @pragma('vm:prefer-inline')
  SuperUser id(int newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  SuperUser call({
    final int? id,
  }) {
    return _$SuperUserImpl(
      id: id ?? _value.id,
    );
  }
}

class $SuperUserCopyWithProxyChain<$Result> {
  $SuperUserCopyWithProxyChain(this._value, this._chain);

  final SuperUser _value;
  final $Result Function(SuperUser update) _chain;

  @pragma('vm:prefer-inline')
  $Result id(int newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  $Result call({
    final int? id,
  }) {
    return _chain(_$SuperUserImpl(
      id: id ?? _value.id,
    ));
  }
}

extension $SuperUserExtension on SuperUser {
  _$SuperUserCopyWithProxy get copyWith => _$SuperUserCopyWithProxy(this);
}
