@DataClass(
  toJson: true,
  fromJson: false,
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

  /// Converts [CamelCaseTest] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'thisVariableWillBeCamelCase': thisVariableWillBeCamelCase,
      'thisvariablewillnotbecamelcase': thisvariablewillnotbecamelcase,
      'thisIsAVariable': thisIsAVariable,
      'aNumber11Variable': aNumber11Variable,
    };
  }
}
