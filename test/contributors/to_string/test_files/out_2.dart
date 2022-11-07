class ToStringTest {
  /// Shorthand constructor
  ToStringTest({
    required this.intValue,
  });

  final int intValue;
  final String _private;
  String notFinal = 'notFinal';

  /// Returns a string with the properties of [ToStringTest]
  @override
  String toString() {
    return """ToStringTest(
  <intValue= $intValue>,
)""";
  }
}
