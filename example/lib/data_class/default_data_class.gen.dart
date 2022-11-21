// AUTO GENERATED - DO NOT MODIFY

part of 'default_data_class.dart';

class _$UserImpl extends User {
  const _$UserImpl({
    required this.username,
    required this.id,
  }) : super._();

  @override
  final String username;

  @override
  final String id;

  @override
  _$UserImpl copyWith({
    final String? username,
    final String? id,
  }) {
    return _$UserImpl(
      username: username ?? this.username,
      id: id ?? this.id,
    );
  }

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is User &&
            runtimeType == other.runtimeType &&
            username == other.username &&
            id == other.id;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      username,
      id,
    ]);
  }

  @override
  String toString() {
    String value = 'User{<optimized out>}';
    assert(() {
      value = 'User@<$hexIdentity>{username: $username, id: $id}';
      return true;
    }());
    return value;
  }
}
