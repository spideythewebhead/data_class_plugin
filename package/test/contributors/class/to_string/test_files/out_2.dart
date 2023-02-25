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
    String value = 'ToStringTest{<optimized out>}';
    assert(() {
      value = 'ToStringTest@<$hexIdentity>{intValue: $intValue}';
      return true;
    }());
    return value;
  }
}
