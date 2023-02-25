@DataClass(
  toJson: true,
  fromJson: false,
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

  /// Converts [KebabCaseTest] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'this-variable-will-be-kebab-case': thisVariableWillBeKebabCase,
      'thisvariablewillnotbekebabcase': thisvariablewillnotbekebabcase,
      'this-is-a-variable': thisIsAVariable,
      'a-number-11-variable': aNumber11Variable,
    };
  }
}
