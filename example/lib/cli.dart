import 'package:data_class_plugin/data_class_plugin.dart';

@DataClass(
  copyWith: true,
  fromJson: true,
  toJson: true,
  hashAndEquals: true,
  $toString: true,
)
class User {
  final String id;

  User(this.id);
}
