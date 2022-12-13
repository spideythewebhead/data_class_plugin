// AUTO GENERATED - DO NOT MODIFY

part of 'simple_usage.dart';

class _$UserImpl extends User {
  _$UserImpl({
    required this.id,
    required this.username,
    this.email,
  }) : super._();

  @override
  final String id;

  @override
  final String username;

  @override
  final String? email;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
    };
  }
}

class _$GetUsersResponseImpl extends GetUsersResponse {
  _$GetUsersResponseImpl({
    required this.ok,
    required this.users,
  }) : super._();

  @override
  final bool ok;

  @override
  final List<User> users;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'ok': ok,
      'users': <dynamic>[
        for (final User i0 in users) i0.toJson(),
      ],
    };
  }
}
