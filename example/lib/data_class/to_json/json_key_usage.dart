import 'package:data_class_plugin/data_class_plugin.dart';

part 'json_key_usage.gen.dart';

@DataClass(
  toJson: true,
  fromJson: false,
  copyWith: false,
  hashAndEquals: false,
  $toString: false,
)
abstract class User {
  User._();

  /// Default constructor
  factory User({
    required String id,
    required String username,
  }) = _$UserImpl;

  @JsonKey<String>(toJson: User._toIdMapper)
  String get id;
  String get username;

  static String _toIdMapper(dynamic id) {
    return '__${id}__';
  }

  /// Converts [User] to a [Map] json
  Map<String, dynamic> toJson();
}
