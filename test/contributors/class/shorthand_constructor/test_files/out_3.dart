class Model {
  /// Shorthand constructor
  Model({
    required this.a,
    required this.b,
    required this.c,
  });

  final TestClass a;
  final List<TestClass> b;
  final Map<String, TestClass> c;
}
