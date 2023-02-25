class ToStringTest {
  /// Shorthand constructor
  ToStringTest({
    required this.intValue,
    required this.doubleValue,
    required this.stringValues,
  });

  final int intValue;
  final double doubleValue;
  final List<String> stringValues;

  /// Returns a string with the properties of [ToStringTest]
  @override
  String toString() {
    String value = 'ToStringTest{<optimized out>}';
    assert(() {
      value =
          'ToStringTest@<$hexIdentity>{intValue: $intValue, doubleValue: $doubleValue, stringValues: $stringValues}';
      return true;
    }());
    return value;
  }
}
