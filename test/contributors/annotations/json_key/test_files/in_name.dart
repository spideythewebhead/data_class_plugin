import 'package:data_class_plugin/data_class_plugin.dart';

@DataClass(
  fromJson: true,
  toJson: true,
  copyWith: false,
  hashAndEquals: false,
  $toString: false,
)
class User {
  User({
    required this.id,
  });

  @JsonKey<String>(name: '_id')
  final String id;
}
