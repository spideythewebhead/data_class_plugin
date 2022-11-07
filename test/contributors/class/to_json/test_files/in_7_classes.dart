class ToJsonTest {
  /// Shorthand constructor
  ToJsonTest({
    required this.a,
    required this.b,
    required this.c,
  });

  final TestClass a;
  final List<TestClass> b;
  final Map<String, TestClass> c;
}

class TestClass {
  /// Shorthand constructor
  TestClass({
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

  /// Converts [TestClass] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'a': a,
      'b': b,
      'c': c,
      'd': d,
      'e': e,
      'g': g,
    };
  }
}

// Generates a [toJson] method that contains a custom class.
