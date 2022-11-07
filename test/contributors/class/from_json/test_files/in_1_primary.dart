class FromJsonTest {
  /// Shorthand constructor
  FromJsonTest({
    required this.a,
    required this.b,
    this.c,
    required this.d,
    required this.e,
    required this.g,
  });

  final int a;
  final String b;
  final String? c;
  final double d;
  final num e;
  final bool g;
}

// Generates a [fromJson] method that contains any primary dart type.
