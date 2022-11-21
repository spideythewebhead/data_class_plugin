// AUTO GENERATED - DO NOT MODIFY

part of 'copy_with.dart';

class _$UserImpl extends User {
  _$UserImpl({
    required this.id,
    required this.username,
    this.permissions,
  }) : super._();

  @override
  final String id;

  @override
  final String username;

  @override
  final List<int>? permissions;

  @override
  _$UserImpl copyWith({
    final String? id,
    final String? username,
    final List<int>? permissions,
  }) {
    return _$UserImpl(
      id: id ?? this.id,
      username: username ?? this.username,
      permissions: permissions ?? this.permissions,
    );
  }
}
