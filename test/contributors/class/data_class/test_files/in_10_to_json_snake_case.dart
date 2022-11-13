import 'package:data_class_plugin/public/annotations.dart';

@DataClass(
  toJson: true,
  fromJson: false,
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
