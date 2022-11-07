class FromJsonTest {
  /// Shorthand constructor
  FromJsonTest({
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

  /// Creates an instance of [TestClass] from [json]
  factory TestClass.fromJson(Map<String, dynamic> json) {
    return TestClass(
      a: json['a'] as int,
      b: json['b'] as String,
      c: json['c'] == null ? null : json['c'] as String,
      d: json['d'] as double,
      e: json['e'] as num,
      g: json['g'] as bool,
    );
  }
}

// Generates a [fromJson] method that contains a custom class.
