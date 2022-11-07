class HashAndEqualsTest {
  /// Shorthand constructor
  HashAndEqualsTest({
    required this.x,
  });

  final int x;
  final int _y;
  int z;
  final int w = 0;
}

// Should create hash and equals overrides that
// includes only 'final public fields without an initializer' in the declaration
