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
    required this.thisIsATestVariable,
  });

  @JsonKey<String>(nameConvention: JsonKeyNameConvention.pascalCase)
  final String thisIsATestVariable;
}
