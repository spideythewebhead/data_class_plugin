// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
// coverage:ignore-file

part of 'json_key.dart';

class _$UserImpl extends User {
  _$UserImpl({
    required this.id,
    required this.username,
    required this.isVerified,
  }) : super.ctor();

  @override
  final int id;

  @override
  final String username;

  @override
  final bool isVerified;

  factory _$UserImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$UserImpl(
      id: json['_id'] as int,
      username: User._customUsernameFromJson(json['username'], json, 'username'),
      isVerified: json['is-verified'] as bool,
    );
  }

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is User &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            username == other.username &&
            isVerified == other.isVerified;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      id,
      username,
      isVerified,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'User{<optimized out>}';
    assert(() {
      toStringOutput = 'User@<$hexIdentity>{id: $id, username: $username, isVerified: $isVerified}';
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

  User isVerified(bool newValue);

  User call({
    final int? id,
    final String? username,
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
  User isVerified(bool newValue) => this(isVerified: newValue);

  @pragma('vm:prefer-inline')
  @override
  User call({
    final int? id,
    final String? username,
    final bool? isVerified,
  }) {
    return _$UserImpl(
      id: id ?? _value.id,
      username: username ?? _value.username,
      isVerified: isVerified ?? _value.isVerified,
    );
  }
}

sealed class $UserCopyWithProxyChain<$Result> {
  factory $UserCopyWithProxyChain(final User value, final $Result Function(User update) chain) =
      _UserCopyWithProxyChainImpl<$Result>;

  $Result id(int newValue);

  $Result username(String newValue);

  $Result isVerified(bool newValue);

  $Result call({
    final int? id,
    final String? username,
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
  $Result isVerified(bool newValue) => this(isVerified: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result call({
    final int? id,
    final String? username,
    final bool? isVerified,
  }) {
    return _chain(_$UserImpl(
      id: id ?? _value.id,
      username: username ?? _value.username,
      isVerified: isVerified ?? _value.isVerified,
    ));
  }
}

extension $UserExtension on User {
  _UserCopyWithProxy get copyWith => _UserCopyWithProxyImpl(this);
}
