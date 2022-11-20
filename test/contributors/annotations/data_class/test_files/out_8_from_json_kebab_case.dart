@DataClass(
  fromJson: true,
  toJson: false,
  copyWith: false,
  $toString: false,
  hashAndEquals: false,
)
class KebabCaseTest {
  /// Shorthand constructor
  KebabCaseTest({
    required this.thisVariableWillBeKebabCase,
    required this.thisvariablewillnotbekebabcase,
    required this.thisIsAVariable,
    required this.aNumber11Variable,
  });

  final String thisVariableWillBeKebabCase;
  final String thisvariablewillnotbekebabcase;
  final String thisIsAVariable;
  final String aNumber11Variable;

  /// Creates an instance of [KebabCaseTest] from [json]
  factory KebabCaseTest.fromJson(Map<dynamic, dynamic> json) {
    return KebabCaseTest(
      thisVariableWillBeKebabCase: json['this-variable-will-be-kebab-case'] as String,
      thisvariablewillnotbekebabcase: json['thisvariablewillnotbekebabcase'] as String,
      thisIsAVariable: json['this-is-a-variable'] as String,
      aNumber11Variable: json['a-number-11-variable'] as String,
    );
  }
}
