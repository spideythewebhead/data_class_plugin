// AUTO GENERATED - DO NOT MODIFY

part of 'json_key_usage.dart';

class _$UserImpl extends User {
  _$UserImpl({
    required this.id,
    required this.username,
  }) : super._();

  @override
  final String id;

  @override
  final String username;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': User._toIdMapper(id),
      'username': username,
    };
  }
}
