class CopyWithTest {
  /// Shorthand constructor
  CopyWithTest({
    required this.x,
    required this.y,
  });

  final int? x;
  final List<int?>? y;

  /// Creates a new instance of [CopyWithTest] with optional new values
  CopyWithTest copyWith({
    final int? x,
    final List<int?>? y,
  }) {
    return CopyWithTest(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
}
