class HashAndEqualsTest {
  /// Shorthand constructor
  HashAndEqualsTest({
    required this.x,
    required this.y,
    required this.z,
  });

  final int x;
  final List<int> y;
  final Map<String, List<int>> z;
}

// Should create equals override that
// uses deepEquality for collections
