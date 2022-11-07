class CopyWithTest {
  /// Shorthand constructor
  CopyWithTest({
    required this.x,
    required this.y,
  });

  final int? x;
  final List<int?>? y;
}

// Should create copyWith function that
// respects nullability on the declared types
