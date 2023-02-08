// AUTO GENERATED - DO NOT MODIFY

part of 'data_class.dart';

class _$UserImpl extends User {
  _$UserImpl({
    required this.id,
    required this.username,
    this.email = '',
  }) : super.ctor();

  @override
  final String id;

  @override
  final String username;

  @override
  final String email;

  factory _$UserImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$UserImpl(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
    };
  }

  @override
  _$UserImpl copyWith({
    final String? id,
    final String? username,
    final String? email,
  }) {
    return _$UserImpl(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is User &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            username == other.username &&
            email == other.email;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      id,
      username,
      email,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'User{<optimized out>}';
    assert(() {
      toStringOutput = 'User@<$hexIdentity>{id: $id, username: $username, email: $email}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => User;
}
