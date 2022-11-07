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

  final List<int> a;
  final List<String> b;
  final List<String?> c;
  final List<double> d;
  final List<num> e;
  final List<bool> g;
}

// Generates a [fromJson] method that contains any primary dart type in a list.
