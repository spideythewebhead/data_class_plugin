class FromJsonTest {
  /// Shorthand constructor
  FromJsonTest({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
  });

  final Map<String, DateTime> a;
  final Map<String, Uri> b;
  final Map<String, Duration> c;
  final Map<String, Enumeration> d;
}

enum Enumeration {
  value1,
  value2,
  value3,
  value4,
  value5;
}

// Generates a [fromJson] method that contains any of the
// default json converters in a map.
