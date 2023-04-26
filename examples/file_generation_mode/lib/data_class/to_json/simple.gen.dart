// AUTO GENERATED - DO NOT MODIFY

// ignore_for_file: library_private_types_in_public_api, unused_element, unused_field

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
      'email': email,
      'isVerified': isVerified,
    };
  }

  @override
  bool operator ==(Object? other) {
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

class _$UserCopyWithProxy {
  _$UserCopyWithProxy(this._value);

  final User _value;

  @pragma('vm:prefer-inline')
  User id(int newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  User username(String newValue) => this(username: newValue);

  @pragma('vm:prefer-inline')
  User email(String? newValue) => this(email: newValue);

  @pragma('vm:prefer-inline')
  User isVerified(bool newValue) => this(isVerified: newValue);

  @pragma('vm:prefer-inline')
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

class $UserCopyWithProxyChain<$Result> {
  $UserCopyWithProxyChain(this._value, this._chain);

  final User _value;
  final $Result Function(User update) _chain;

  @pragma('vm:prefer-inline')
  $Result id(int newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  $Result username(String newValue) => this(username: newValue);

  @pragma('vm:prefer-inline')
  $Result email(String? newValue) => this(email: newValue);

  @pragma('vm:prefer-inline')
  $Result isVerified(bool newValue) => this(isVerified: newValue);

  @pragma('vm:prefer-inline')
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
  _$UserCopyWithProxy get copyWith => _$UserCopyWithProxy(this);
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
  bool operator ==(Object? other) {
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

class _$GetUsersResultCopyWithProxy {
  _$GetUsersResultCopyWithProxy(this._value);

  final GetUsersResult _value;

  @pragma('vm:prefer-inline')
  GetUsersResult users(List<User> newValue) => this(users: newValue);

  @pragma('vm:prefer-inline')
  GetUsersResult call({
    final List<User>? users,
  }) {
    return _$GetUsersResultImpl(
      users: users ?? _value.users,
    );
  }
}

class $GetUsersResultCopyWithProxyChain<$Result> {
  $GetUsersResultCopyWithProxyChain(this._value, this._chain);

  final GetUsersResult _value;
  final $Result Function(GetUsersResult update) _chain;

  @pragma('vm:prefer-inline')
  $Result users(List<User> newValue) => this(users: newValue);

  @pragma('vm:prefer-inline')
  $Result call({
    final List<User>? users,
  }) {
    return _chain(_$GetUsersResultImpl(
      users: users ?? _value.users,
    ));
  }
}

extension $GetUsersResultExtension on GetUsersResult {
  _$GetUsersResultCopyWithProxy get copyWith => _$GetUsersResultCopyWithProxy(this);
}
