// AUTO GENERATED - DO NOT MODIFY

// ignore_for_file: library_private_types_in_public_api, unused_element, unused_field

part of 'inheritance.dart';

class _$RectangleImpl extends Rectangle {
  _$RectangleImpl() : super.ctor();

  @override
  bool operator ==(Object? other) {
    return identical(this, other) || other is Rectangle && runtimeType == other.runtimeType;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'Rectangle{<optimized out>}';
    assert(() {
      toStringOutput = 'Rectangle@<$hexIdentity>{}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => Rectangle;
}

class _$RectangleCopyWithProxy {
  _$RectangleCopyWithProxy(this._value);

  final Rectangle _value;

  @pragma('vm:prefer-inline')
  Rectangle call() {
    return _$RectangleImpl();
  }
}

class $RectangleCopyWithProxyChain<$Result> {
  $RectangleCopyWithProxyChain(this._value, this._chain);

  final Rectangle _value;
  final $Result Function(Rectangle update) _chain;

  @pragma('vm:prefer-inline')
  $Result call() {
    return _chain(_$RectangleImpl());
  }
}

extension $RectangleExtension on Rectangle {
  _$RectangleCopyWithProxy get copyWith => _$RectangleCopyWithProxy(this);
}

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
  bool operator ==(Object? other) {
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

class _$UserCopyWithProxy {
  _$UserCopyWithProxy(this._value);

  final User _value;

  @pragma('vm:prefer-inline')
  User id(int newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  User username(String newValue) => this(username: newValue);

  @pragma('vm:prefer-inline')
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

class $UserCopyWithProxyChain<$Result> {
  $UserCopyWithProxyChain(this._value, this._chain);

  final User _value;
  final $Result Function(User update) _chain;

  @pragma('vm:prefer-inline')
  $Result id(int newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  $Result username(String newValue) => this(username: newValue);

  @pragma('vm:prefer-inline')
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
  _$UserCopyWithProxy get copyWith => _$UserCopyWithProxy(this);
}

class _$SuperUserImpl extends SuperUser {
  _$SuperUserImpl({
    required this.id,
    required this.username,
    required this.nickname,
    required this.isEnabled,
  }) : super.ctor();

  @override
  final int id;

  @override
  final String username;

  @override
  final String nickname;

  @override
  final bool isEnabled;

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is SuperUser &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            username == other.username &&
            nickname == other.nickname &&
            isEnabled == other.isEnabled;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      id,
      username,
      nickname,
      isEnabled,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'SuperUser{<optimized out>}';
    assert(() {
      toStringOutput =
          'SuperUser@<$hexIdentity>{id: $id, username: $username, nickname: $nickname, isEnabled: $isEnabled}';
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
  SuperUser username(String newValue) => this(username: newValue);

  @pragma('vm:prefer-inline')
  SuperUser nickname(String newValue) => this(nickname: newValue);

  @pragma('vm:prefer-inline')
  SuperUser isEnabled(bool newValue) => this(isEnabled: newValue);

  @pragma('vm:prefer-inline')
  SuperUser call({
    final int? id,
    final String? username,
    final String? nickname,
    final bool? isEnabled,
  }) {
    return _$SuperUserImpl(
      id: id ?? _value.id,
      username: username ?? _value.username,
      nickname: nickname ?? _value.nickname,
      isEnabled: isEnabled ?? _value.isEnabled,
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
  $Result username(String newValue) => this(username: newValue);

  @pragma('vm:prefer-inline')
  $Result nickname(String newValue) => this(nickname: newValue);

  @pragma('vm:prefer-inline')
  $Result isEnabled(bool newValue) => this(isEnabled: newValue);

  @pragma('vm:prefer-inline')
  $Result call({
    final int? id,
    final String? username,
    final String? nickname,
    final bool? isEnabled,
  }) {
    return _chain(_$SuperUserImpl(
      id: id ?? _value.id,
      username: username ?? _value.username,
      nickname: nickname ?? _value.nickname,
      isEnabled: isEnabled ?? _value.isEnabled,
    ));
  }
}

extension $SuperUserExtension on SuperUser {
  _$SuperUserCopyWithProxy get copyWith => _$SuperUserCopyWithProxy(this);
}
