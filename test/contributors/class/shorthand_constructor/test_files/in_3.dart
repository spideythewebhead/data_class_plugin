class Model {
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
    required this.f,
  });

  final int a;
  final String b;
  final String? c;
  final double d;
  final num e;
  final bool f;
}

// Should create a constructor that includes a custom class
