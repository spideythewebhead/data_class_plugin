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

  /// Returns a hash code based on [this] properties
  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      x,
      y,
      z,
    ]);
  }

  /// Compares [this] with [other] on identity, class type, and properties
  /// *with deep comparison on collections*
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HashAndEqualsTest &&
            x == other.x &&
            deepEquality(y, other.y) &&
            deepEquality(z, other.z);
  }
}
