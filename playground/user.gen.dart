// AUTO GENERATED - DO NOT MODIFY

part of 'user.dart';

class _$UserImpl extends User {
  const _$UserImpl({
    required this.username,
  }) : super._();

  @override
  final String username;

  factory _$UserImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$UserImpl(
      username: json['_uname'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '_uname': username,
    };
  }

  @override
  _$UserImpl copyWith({
    final String? username,
  }) {
    return _$UserImpl(
      username: username ?? this.username,
    );
  }

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is User &&
            runtimeType == other.runtimeType &&
            username == other.username;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      username,
    ]);
  }

  @override
  String toString() {
    String value = 'User{<optimized out>}';
    assert(() {
      value = 'User@<$hexIdentity>{username: $username}';
      return true;
    }());
    return value;
  }
}
