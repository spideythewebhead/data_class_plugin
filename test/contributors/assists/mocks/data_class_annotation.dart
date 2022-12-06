import 'package:data_class_plugin/data_class_plugin.dart';

@DataClass()
class User {
  const User(this.id);
  final String id;
}
