// AUTO GENERATED - DO NOT MODIFY

part of 'simple_usage.dart';

class _$UserImpl extends User {
  _$UserImpl({
    required this.id,
    required this.username,
  }) : super._();

  @override
  final String id;

  @override
  final String username;

  factory _$UserImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$UserImpl(
      id: json['id'] as String,
      username: json['username'] as String,
    );
  }
}
