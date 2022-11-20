import 'package:data_class_plugin/data_class_plugin.dart';

@DataClass(
  fromJson: true,
  toJson: false,
  copyWith: false,
  $toString: false,
  hashAndEquals: false,
)
class SnakeCaseTest {
  final String thisVariableWillBeSnakeCase;
  final String onewordvariable;
  final String thisIsAVariable;
  final String aNumber11Variable;
}
