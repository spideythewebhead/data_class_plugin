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

class _$UserCopyWithProxy {
  _$UserCopyWithProxy(this._value);

  final User _value;

  @pragma('vm:prefer-inline')
  User id(int newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  User username(String newValue) => this(username: newValue);

  @pragma('vm:prefer-inline')
  User isVerified(bool newValue) => this(isVerified: newValue);

  @pragma('vm:prefer-inline')
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

class $UserCopyWithProxyChain<$Result> {
  $UserCopyWithProxyChain(this._value, this._chain);

  final User _value;
  final $Result Function(User update) _chain;

  @pragma('vm:prefer-inline')
  $Result id(int newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  $Result username(String newValue) => this(username: newValue);

  @pragma('vm:prefer-inline')
  $Result isVerified(bool newValue) => this(isVerified: newValue);

  @pragma('vm:prefer-inline')
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
  _$UserCopyWithProxy get copyWith => _$UserCopyWithProxy(this);
}
