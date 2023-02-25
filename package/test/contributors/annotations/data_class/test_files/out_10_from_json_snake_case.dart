@DataClass(
  fromJson: true,
  toJson: false,
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

  /// Creates an instance of [SnakeCaseTest] from [json]
  factory SnakeCaseTest.fromJson(Map<dynamic, dynamic> json) {
    return SnakeCaseTest(
      thisVariableWillBeSnakeCase: json['this_variable_will_be_snake_case'] as String,
      onewordvariable: json['onewordvariable'] as String,
      thisIsAVariable: json['this_is_a_variable'] as String,
      aNumber11Variable: json['a_number_11_variable'] as String,
    );
  }
}
