// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
// coverage:ignore-file

part of 'inheritance.dart';

class _$RectangleImpl extends Rectangle {
  _$RectangleImpl({
    required this.width,
    required this.height,
  }) : super.ctor();

  @override
  final double width;

  @override
  final double height;

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is Rectangle &&
            runtimeType == other.runtimeType &&
            width == other.width &&
            height == other.height;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      width,
      height,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'Rectangle{<optimized out>}';
    assert(() {
      toStringOutput = 'Rectangle@<$hexIdentity>{width: $width, height: $height}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => Rectangle;
}

abstract interface class _RectangleCopyWithProxy {
  Rectangle width(double newValue);

  Rectangle height(double newValue);

  Rectangle call({
    final double? width,
    final double? height,
  });
}

class _RectangleCopyWithProxyImpl implements _RectangleCopyWithProxy {
  _RectangleCopyWithProxyImpl(this._value);

  final Rectangle _value;

  @pragma('vm:prefer-inline')
  @override
  Rectangle width(double newValue) => this(width: newValue);

  @pragma('vm:prefer-inline')
  @override
  Rectangle height(double newValue) => this(height: newValue);

  @pragma('vm:prefer-inline')
  @override
  Rectangle call({
    final double? width,
    final double? height,
  }) {
    return _$RectangleImpl(
      width: width ?? _value.width,
      height: height ?? _value.height,
    );
  }
}

sealed class $RectangleCopyWithProxyChain<$Result> {
  factory $RectangleCopyWithProxyChain(
          final Rectangle value, final $Result Function(Rectangle update) chain) =
      _RectangleCopyWithProxyChainImpl<$Result>;

  $Result width(double newValue);

  $Result height(double newValue);

  $Result call({
    final double? width,
    final double? height,
  });
}

class _RectangleCopyWithProxyChainImpl<$Result> implements $RectangleCopyWithProxyChain<$Result> {
  _RectangleCopyWithProxyChainImpl(this._value, this._chain);

  final Rectangle _value;
  final $Result Function(Rectangle update) _chain;

  @pragma('vm:prefer-inline')
  @override
  $Result width(double newValue) => this(width: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result height(double newValue) => this(height: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result call({
    final double? width,
    final double? height,
  }) {
    return _chain(_$RectangleImpl(
      width: width ?? _value.width,
      height: height ?? _value.height,
    ));
  }
}

extension $RectangleExtension on Rectangle {
  _RectangleCopyWithProxy get copyWith => _RectangleCopyWithProxyImpl(this);
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

abstract interface class _SuperUserCopyWithProxy {
  SuperUser id(int newValue);

  SuperUser username(String newValue);

  SuperUser nickname(String newValue);

  SuperUser isEnabled(bool newValue);

  SuperUser call({
    final int? id,
    final String? username,
    final String? nickname,
    final bool? isEnabled,
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
  SuperUser nickname(String newValue) => this(nickname: newValue);

  @pragma('vm:prefer-inline')
  @override
  SuperUser isEnabled(bool newValue) => this(isEnabled: newValue);

  @pragma('vm:prefer-inline')
  @override
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

sealed class $SuperUserCopyWithProxyChain<$Result> {
  factory $SuperUserCopyWithProxyChain(
          final SuperUser value, final $Result Function(SuperUser update) chain) =
      _SuperUserCopyWithProxyChainImpl<$Result>;

  $Result id(int newValue);

  $Result username(String newValue);

  $Result nickname(String newValue);

  $Result isEnabled(bool newValue);

  $Result call({
    final int? id,
    final String? username,
    final String? nickname,
    final bool? isEnabled,
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
  $Result nickname(String newValue) => this(nickname: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result isEnabled(bool newValue) => this(isEnabled: newValue);

  @pragma('vm:prefer-inline')
  @override
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
  _SuperUserCopyWithProxy get copyWith => _SuperUserCopyWithProxyImpl(this);
}
