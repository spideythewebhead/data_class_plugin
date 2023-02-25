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
}

// Should create a [toString] override for [ToStringTest]
// using doubleValue and stringValues
