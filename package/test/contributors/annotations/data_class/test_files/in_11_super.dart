import 'package:data_class_plugin/data_class_plugin.dart';

@DataClass()
class AdminUser extends User {
  final String username;
}

abstract class User {
  /// Shorthand constructor
  User({
    required this.id,
  });

  final String id;
}
