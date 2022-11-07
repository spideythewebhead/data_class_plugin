class HashAndEqualsTest {
  /// Shorthand constructor
  HashAndEqualsTest({
    required this.x,
  });

  final int x;
  final int _y;
  int z;
  final int w = 0;

  /// Returns a hash code based on [this] properties
  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      x,
    ]);
  }

  /// Compares [this] with [other] on identity, class type, and properties
  /// *with deep comparison on collections*
  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is HashAndEqualsTest && x == other.x;
  }
}
