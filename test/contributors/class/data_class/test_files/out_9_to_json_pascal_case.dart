@DataClass(
  toJson: true,
  fromJson: false,
  copyWith: false,
  $toString: false,
  hashAndEquals: false,
)
class PascalCaseTest {
  /// Shorthand constructor
  PascalCaseTest({
    required this.thisVariableWillBePascalCase,
    required this.onewordvariable,
    required this.thisIsAVariable,
    required this.aNumber11Variable,
  });

  final String thisVariableWillBePascalCase;
  final String onewordvariable;
  final String thisIsAVariable;
  final String aNumber11Variable;

  /// Converts [PascalCaseTest] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'ThisVariableWillBePascalCase': thisVariableWillBePascalCase,
      'Onewordvariable': onewordvariable,
      'ThisIsAVariable': thisIsAVariable,
      'ANumber11Variable': aNumber11Variable,
    };
  }
}
