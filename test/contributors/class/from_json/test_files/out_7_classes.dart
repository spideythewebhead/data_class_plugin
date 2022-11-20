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

  /// Creates an instance of [FromJsonTest] from [json]
  factory FromJsonTest.fromJson(Map<dynamic, dynamic> json) {
    return FromJsonTest(
      a: TestClass.fromJson(json['a']),
      b: <TestClass>[
        for (final dynamic i0 in (json['b'] as List<dynamic>)) TestClass.fromJson(i0),
      ],
      c: <String, TestClass>{
        for (final MapEntry<dynamic, dynamic> e0 in (json['c'] as Map<dynamic, dynamic>).entries)
          e0.key: TestClass.fromJson(e0.value),
      },
    );
  }
}
