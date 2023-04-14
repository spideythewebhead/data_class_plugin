import 'package:data_class_plugin/data_class_plugin.dart';

@DataClass()
class User {
  int get id;

  String get username;

  @DefaultValue('')
  String get email;
}
