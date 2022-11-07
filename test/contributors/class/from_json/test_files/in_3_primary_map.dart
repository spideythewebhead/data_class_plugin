class FromJsonTest {
  /// Shorthand constructor
  FromJsonTest({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.e,
    required this.g,
  });

  final Map<String, int> a;
  final Map<String, String> b;
  final Map<String, String?> c;
  final Map<String, double> d;
  final Map<String, num> e;
  final Map<String, bool> g;
}

// Generates a [fromJson] method that contains any primary dart type in a map.
