import 'package:data_class_plugin/data_class_plugin.dart';

part 'copy_with.gen.dart';

@DataClass(
  copyWith: true,
  fromJson: false,
  toJson: false,
  hashAndEquals: false,
  $toString: false,
)
abstract class User {
  User._();

  /// Default constructor
  factory User({
    required String id,
    required String username,
    List<int>? permissions,
  }) = _$UserImpl;

  String get id;
  String get username;
  List<int>? get permissions;

  /// Creates a new instance of [User] with optional new values
  User copyWith({
    final String? id,
    final String? username,
    final List<int>? permissions,
  });
}
