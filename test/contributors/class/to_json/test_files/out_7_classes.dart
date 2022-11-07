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

  /// Converts [ToJsonTest] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'a': a.toJson(),
      'b': <dynamic>[
        for (final TestClass i0 in b) i0.toJson(),
      ],
      'c': <String, dynamic>{
        for (final MapEntry<String, TestClass> e0 in c.entries) e0.key: e0.value.toJson(),
      },
    };
  }
}
