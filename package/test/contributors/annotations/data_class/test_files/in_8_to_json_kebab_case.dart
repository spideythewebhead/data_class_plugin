import 'package:data_class_plugin/data_class_plugin.dart';

@DataClass(
  toJson: true,
  fromJson: false,
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
