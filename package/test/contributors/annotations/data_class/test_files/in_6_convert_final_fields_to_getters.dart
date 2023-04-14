import 'package:data_class_plugin/data_class_plugin.dart';

@DataClass()
class User {
  final int id;
  final String username;

  @DefaultValue('')
  String get email;
}
