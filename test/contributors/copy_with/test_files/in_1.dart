class CopyWithTest {
  /// Shorthand constructor
  CopyWithTest({
    required this.x,
  });

  final int x;
  final int _y;
  int z;
  final int w = 0;
}

// Should create copyWith function that
// includes only 'final public fields without an initializer' in the declaration
