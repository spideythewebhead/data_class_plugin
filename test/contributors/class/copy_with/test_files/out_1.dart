class CopyWithTest {
  /// Shorthand constructor
  CopyWithTest({
    required this.x,
  });

  final int x;
  final int _y;
  int z;
  final int w = 0;

  /// Creates a new instance of [CopyWithTest] with optional new values
  CopyWithTest copyWith({
    final int? x,
  }) {
    return CopyWithTest(
      x: x ?? this.x,
    );
  }
}
