// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
// coverage:ignore-file

part of 'simple.dart';

class _$UserImpl extends User {
  _$UserImpl({
    required this.id,
    required this.username,
    this.email,
    required this.isVerified,
  }) : super.ctor();

  @override
  final int id;

  @override
  final String username;

  @override
  final String? email;

  @override
  final bool isVerified;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      if (email != null) 'email': email,
      'isVerified': isVerified,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is User &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            username == other.username &&
            email == other.email &&
            isVerified == other.isVerified;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      id,
      username,
      email,
      isVerified,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'User{<optimized out>}';
    assert(() {
      toStringOutput =
          'User@<$hexIdentity>{id: $id, username: $username, email: $email, isVerified: $isVerified}';
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

  User email(String? newValue);

  User isVerified(bool newValue);

  User call({
    final int? id,
    final String? username,
    final String? email,
    final bool? isVerified,
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
  User email(String? newValue) => this(email: newValue);

  @pragma('vm:prefer-inline')
  @override
  User isVerified(bool newValue) => this(isVerified: newValue);

  @pragma('vm:prefer-inline')
  @override
  User call({
    final int? id,
    final String? username,
    final Object? email = const Object(),
    final bool? isVerified,
  }) {
    return _$UserImpl(
      id: id ?? _value.id,
      username: username ?? _value.username,
      email: identical(email, const Object()) ? _value.email : (email as String?),
      isVerified: isVerified ?? _value.isVerified,
    );
  }
}

sealed class $UserCopyWithProxyChain<$Result> {
  factory $UserCopyWithProxyChain(final User value, final $Result Function(User update) chain) =
      _UserCopyWithProxyChainImpl<$Result>;

  $Result id(int newValue);

  $Result username(String newValue);

  $Result email(String? newValue);

  $Result isVerified(bool newValue);

  $Result call({
    final int? id,
    final String? username,
    final String? email,
    final bool? isVerified,
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
  $Result email(String? newValue) => this(email: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result isVerified(bool newValue) => this(isVerified: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result call({
    final int? id,
    final String? username,
    final Object? email = const Object(),
    final bool? isVerified,
  }) {
    return _chain(_$UserImpl(
      id: id ?? _value.id,
      username: username ?? _value.username,
      email: identical(email, const Object()) ? _value.email : (email as String?),
      isVerified: isVerified ?? _value.isVerified,
    ));
  }
}

extension $UserExtension on User {
  _UserCopyWithProxy get copyWith => _UserCopyWithProxyImpl(this);
}

class _$GetUsersResultImpl extends GetUsersResult {
  _$GetUsersResultImpl({
    required List<User> users,
  })  : _users = users,
        super.ctor();

  @override
  List<User> get users => List<User>.unmodifiable(_users);
  final List<User> _users;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'users': <dynamic>[
        for (final User i0 in users) i0.toJson(),
      ],
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is GetUsersResult &&
            runtimeType == other.runtimeType &&
            deepEquality(users, other.users);
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'GetUsersResult{<optimized out>}';
    assert(() {
      toStringOutput = 'GetUsersResult@<$hexIdentity>{users: $users}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => GetUsersResult;
}

abstract interface class _GetUsersResultCopyWithProxy {
  GetUsersResult users(List<User> newValue);

  GetUsersResult call({
    final List<User>? users,
  });
}

class _GetUsersResultCopyWithProxyImpl implements _GetUsersResultCopyWithProxy {
  _GetUsersResultCopyWithProxyImpl(this._value);

  final GetUsersResult _value;

  @pragma('vm:prefer-inline')
  @override
  GetUsersResult users(List<User> newValue) => this(users: newValue);

  @pragma('vm:prefer-inline')
  @override
  GetUsersResult call({
    final List<User>? users,
  }) {
    return _$GetUsersResultImpl(
      users: users ?? _value.users,
    );
  }
}

sealed class $GetUsersResultCopyWithProxyChain<$Result> {
  factory $GetUsersResultCopyWithProxyChain(
          final GetUsersResult value, final $Result Function(GetUsersResult update) chain) =
      _GetUsersResultCopyWithProxyChainImpl<$Result>;

  $Result users(List<User> newValue);

  $Result call({
    final List<User>? users,
  });
}

class _GetUsersResultCopyWithProxyChainImpl<$Result>
    implements $GetUsersResultCopyWithProxyChain<$Result> {
  _GetUsersResultCopyWithProxyChainImpl(this._value, this._chain);

  final GetUsersResult _value;
  final $Result Function(GetUsersResult update) _chain;

  @pragma('vm:prefer-inline')
  @override
  $Result users(List<User> newValue) => this(users: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result call({
    final List<User>? users,
  }) {
    return _chain(_$GetUsersResultImpl(
      users: users ?? _value.users,
    ));
  }
}

extension $GetUsersResultExtension on GetUsersResult {
  _GetUsersResultCopyWithProxy get copyWith => _GetUsersResultCopyWithProxyImpl(this);
}
