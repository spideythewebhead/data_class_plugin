import 'package:data_class_plugin/public/annotations.dart';

class User {
  User({
    required this.id,
    required this.username,
  });

  @MapKey(toMap: _toIdMapper)
  final String id;
  final String username;

  static String _toIdMapper(dynamic id) {
    return '__${id}__';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': User._toIdMapper(id),
      'username': username,
    };
  }
}
