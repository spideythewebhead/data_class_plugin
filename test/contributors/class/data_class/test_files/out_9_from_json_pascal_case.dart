@DataClass(
  fromJson: true,
  toJson: false,
  copyWith: false,
  $toString: false,
  hashAndEquals: false,
)
class PascalCaseTest {
  final String thisVariableWillBePascalCase;
  final String onewordvariable;
  final String thisIsAVariable;
  final String aNumber11Variable;

  /// Creates an instance of [PascalCaseTest] from [json]
  factory PascalCaseTest.fromJson(Map<String, dynamic> json) {
    return PascalCaseTest(
      thisVariableWillBePascalCase: json['ThisVariableWillBePascalCase'] as String,
      onewordvariable: json['Onewordvariable'] as String,
      thisIsAVariable: json['ThisIsAVariable'] as String,
      aNumber11Variable: json['ANumber11Variable'] as String,
    );
  }
}
