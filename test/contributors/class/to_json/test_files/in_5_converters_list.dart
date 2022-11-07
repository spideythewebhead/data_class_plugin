class ToJsonTest {
  /// Shorthand constructor
  ToJsonTest({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
  });

  final List<DateTime> a;
  final List<Uri> b;
  final List<Duration> c;
  final List<Enumeration> d;
}

enum Enumeration {
  value1,
  value2,
  value3,
  value4,
  value5;
}

// Generates a [toJson] method that contains any of the
// default json converters in a list.
