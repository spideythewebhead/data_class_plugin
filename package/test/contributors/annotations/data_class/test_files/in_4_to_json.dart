import 'package:data_class_plugin/data_class_plugin.dart';

@DataClass(
  toJson: true,
)
class User {
  int get id;

  String get username;
}
