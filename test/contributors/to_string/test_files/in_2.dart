class ToStringTest {
  /// Shorthand constructor
  ToStringTest({
    required this.intValue,
  });

  final int intValue;
  final String _private;
  String notFinal = 'notFinal';
}

// Should create a [toString] override for [ToStringTest] intValue
// and ignoring _private and notFinal
