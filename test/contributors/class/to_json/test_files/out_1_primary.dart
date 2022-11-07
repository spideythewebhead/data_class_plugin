class ToJsonTest {
  /// Shorthand constructor
  ToJsonTest({
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

  /// Converts [ToJsonTest] to a [Map] json
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
