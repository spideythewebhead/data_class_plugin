@DataClass(
  toJson: true,
  fromJson: false,
  copyWith: false,
  $toString: false,
  hashAndEquals: false,
)
class SnakeCaseTest {
  /// Shorthand constructor
  SnakeCaseTest({
    required this.thisVariableWillBeSnakeCase,
    required this.onewordvariable,
    required this.thisIsAVariable,
    required this.aNumber11Variable,
  });

  final String thisVariableWillBeSnakeCase;
  final String onewordvariable;
  final String thisIsAVariable;
  final String aNumber11Variable;

  /// Converts [SnakeCaseTest] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'this_variable_will_be_snake_case': thisVariableWillBeSnakeCase,
      'onewordvariable': onewordvariable,
      'this_is_a_variable': thisIsAVariable,
      'a_number_11_variable': aNumber11Variable,
    };
  }
}
