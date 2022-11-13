import 'package:data_class_plugin/public/annotations.dart';

@DataClass(
  fromJson: true,
  toJson: false,
  copyWith: false,
  $toString: false,
  hashAndEquals: false,
)
class KebabCaseTest {
  final String thisVariableWillBeKebabCase;
  final String thisvariablewillnotbekebabcase;
  final String thisIsAVariable;
  final String aNumber11Variable;
}
