@DataClass(
  fromJson: true,
  toJson: false,
  copyWith: false,
  $toString: false,
  hashAndEquals: false,
)
class CamelCaseTest {
  /// Shorthand constructor
  CamelCaseTest({
    required this.thisVariableWillBeCamelCase,
    required this.thisvariablewillnotbecamelcase,
    required this.thisIsAVariable,
    required this.aNumber11Variable,
  });

  final String thisVariableWillBeCamelCase;
  final String thisvariablewillnotbecamelcase;
  final String thisIsAVariable;
  final String aNumber11Variable;

  /// Creates an instance of [CamelCaseTest] from [json]
  factory CamelCaseTest.fromJson(Map<dynamic, dynamic> json) {
    return CamelCaseTest(
      thisVariableWillBeCamelCase: json['thisVariableWillBeCamelCase'] as String,
      thisvariablewillnotbecamelcase: json['thisvariablewillnotbecamelcase'] as String,
      thisIsAVariable: json['thisIsAVariable'] as String,
      aNumber11Variable: json['aNumber11Variable'] as String,
    );
  }
}
