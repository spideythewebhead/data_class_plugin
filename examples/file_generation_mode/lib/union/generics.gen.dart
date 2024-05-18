// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
// coverage:ignore-file

part of 'generics.dart';

class _$UserImpl extends User {
  _$UserImpl({
    required this.id,
    required this.username,
  }) : super.ctor();

  @override
  final int id;

  @override
  final String username;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is User &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            username == other.username;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      id,
      username,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'User{<optimized out>}';
    assert(() {
      toStringOutput = 'User@<$hexIdentity>{id: $id, username: $username}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => User;
}

abstract interface class _UserCopyWithProxy {
  User id(int newValue);

  User username(String newValue);

  User call({
    final int? id,
    final String? username,
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
  User username(String newValue) => this(username: newValue);

  @pragma('vm:prefer-inline')
  @override
  User call({
    final int? id,
    final String? username,
  }) {
    return _$UserImpl(
      id: id ?? _value.id,
      username: username ?? _value.username,
    );
  }
}

sealed class $UserCopyWithProxyChain<$Result> {
  factory $UserCopyWithProxyChain(final User value, final $Result Function(User update) chain) =
      _UserCopyWithProxyChainImpl<$Result>;

  $Result id(int newValue);

  $Result username(String newValue);

  $Result call({
    final int? id,
    final String? username,
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
  $Result username(String newValue) => this(username: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result call({
    final int? id,
    final String? username,
  }) {
    return _chain(_$UserImpl(
      id: id ?? _value.id,
      username: username ?? _value.username,
    ));
  }
}

extension $UserExtension on User {
  _UserCopyWithProxy get copyWith => _UserCopyWithProxyImpl(this);
}

class _$SuperUserImpl extends SuperUser {
  _$SuperUserImpl({
    required this.id,
    required this.username,
  }) : super.ctor();

  @override
  final int id;

  @override
  final String username;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SuperUser &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            username == other.username;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      id,
      username,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'SuperUser{<optimized out>}';
    assert(() {
      toStringOutput = 'SuperUser@<$hexIdentity>{id: $id, username: $username}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => SuperUser;
}

abstract interface class _SuperUserCopyWithProxy {
  SuperUser id(int newValue);

  SuperUser username(String newValue);

  SuperUser call({
    final int? id,
    final String? username,
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
  SuperUser username(String newValue) => this(username: newValue);

  @pragma('vm:prefer-inline')
  @override
  SuperUser call({
    final int? id,
    final String? username,
  }) {
    return _$SuperUserImpl(
      id: id ?? _value.id,
      username: username ?? _value.username,
    );
  }
}

sealed class $SuperUserCopyWithProxyChain<$Result> {
  factory $SuperUserCopyWithProxyChain(
          final SuperUser value, final $Result Function(SuperUser update) chain) =
      _SuperUserCopyWithProxyChainImpl<$Result>;

  $Result id(int newValue);

  $Result username(String newValue);

  $Result call({
    final int? id,
    final String? username,
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
  $Result username(String newValue) => this(username: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result call({
    final int? id,
    final String? username,
  }) {
    return _chain(_$SuperUserImpl(
      id: id ?? _value.id,
      username: username ?? _value.username,
    ));
  }
}

extension $SuperUserExtension on SuperUser {
  _SuperUserCopyWithProxy get copyWith => _SuperUserCopyWithProxyImpl(this);
}

extension $AsyncResult<T> on AsyncResult<T> {
  R when<R>({
    required R Function() loading,
    required R Function(AsyncResultData<T> value) data,
    required R Function(AsyncResultError<T> value) error,
  }) {
    if (this is AsyncResultLoading<T>) {
      return loading();
    }
    if (this is AsyncResultData<T>) {
      return data(this as AsyncResultData<T>);
    }
    if (this is AsyncResultError<T>) {
      return error(this as AsyncResultError<T>);
    }
    throw UnimplementedError('$runtimeType is not generated by this plugin');
  }

  R maybeWhen<R>({
    R Function()? loading,
    R Function(AsyncResultData<T> value)? data,
    R Function(AsyncResultError<T> value)? error,
    required R Function() orElse,
  }) {
    if (loading != null && this is AsyncResultLoading<T>) {
      return loading();
    }
    if (data != null && this is AsyncResultData<T>) {
      return data(this as AsyncResultData<T>);
    }
    if (error != null && this is AsyncResultError<T>) {
      return error(this as AsyncResultError<T>);
    }
    return orElse();
  }
}

class AsyncResultLoading<T> extends AsyncResult<T> {
  const AsyncResultLoading() : super._();

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
    ]);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AsyncResultLoading<T> && runtimeType == other.runtimeType;
  }

  @override
  String toString() {
    String toStringOutput = 'AsyncResultLoading{<optimized out>}';
    assert(() {
      toStringOutput = 'AsyncResultLoading@<$hexIdentity>{}';
      return true;
    }());
    return toStringOutput;
  }
}

class AsyncResultData<T> extends AsyncResult<T> {
  AsyncResultData(
    this.data,
  ) : super._();

  final T data;

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      data,
    ]);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AsyncResultData<T> && runtimeType == other.runtimeType && data == other.data;
  }

  @override
  String toString() {
    String toStringOutput = 'AsyncResultData{<optimized out>}';
    assert(() {
      toStringOutput = 'AsyncResultData@<$hexIdentity>{data: $data}';
      return true;
    }());
    return toStringOutput;
  }
}

class AsyncResultError<T> extends AsyncResult<T> {
  AsyncResultError(
    this.error, {
    this.stackTrace,
  }) : super._();

  final Object error;

  final StackTrace? stackTrace;

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      error,
      stackTrace,
    ]);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AsyncResultError<T> &&
            runtimeType == other.runtimeType &&
            error == other.error &&
            stackTrace == other.stackTrace;
  }

  @override
  String toString() {
    String toStringOutput = 'AsyncResultError{<optimized out>}';
    assert(() {
      toStringOutput = 'AsyncResultError@<$hexIdentity>{error: $error, stackTrace: $stackTrace}';
      return true;
    }());
    return toStringOutput;
  }
}

extension $UnionWithGenericConstraints<T extends User> on UnionWithGenericConstraints<T> {
  R when<R>({
    required R Function(UnionWithGenericConstraintsData<T> value) data,
  }) {
    if (this is UnionWithGenericConstraintsData<T>) {
      return data(this as UnionWithGenericConstraintsData<T>);
    }
    throw UnimplementedError('$runtimeType is not generated by this plugin');
  }

  R maybeWhen<R>({
    R Function(UnionWithGenericConstraintsData<T> value)? data,
    required R Function() orElse,
  }) {
    if (data != null && this is UnionWithGenericConstraintsData<T>) {
      return data(this as UnionWithGenericConstraintsData<T>);
    }
    return orElse();
  }
}

class UnionWithGenericConstraintsData<T extends User> extends UnionWithGenericConstraints<T> {
  UnionWithGenericConstraintsData(
    this.data,
  ) : super._();

  final T data;

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      data,
    ]);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UnionWithGenericConstraintsData<T> &&
            runtimeType == other.runtimeType &&
            data == other.data;
  }

  @override
  String toString() {
    String toStringOutput = 'UnionWithGenericConstraintsData{<optimized out>}';
    assert(() {
      toStringOutput = 'UnionWithGenericConstraintsData@<$hexIdentity>{data: $data}';
      return true;
    }());
    return toStringOutput;
  }
}
