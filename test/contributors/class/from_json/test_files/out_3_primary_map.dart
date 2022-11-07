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

  final Map<String, int> a;
  final Map<String, String> b;
  final Map<String, String?> c;
  final Map<String, double> d;
  final Map<String, num> e;
  final Map<String, bool> g;

  /// Creates an instance of [FromJsonTest] from [json]
  factory FromJsonTest.fromJson(Map<String, dynamic> json) {
    return FromJsonTest(
      a: <String, int>{
        for (final MapEntry<String, dynamic> e0 in (json['a'] as Map<String, dynamic>).entries)
          e0.key: e0.value as int,
      },
      b: <String, String>{
        for (final MapEntry<String, dynamic> e0 in (json['b'] as Map<String, dynamic>).entries)
          e0.key: e0.value as String,
      },
      c: <String, String?>{
        for (final MapEntry<String, dynamic> e0 in (json['c'] as Map<String, dynamic>).entries)
          e0.key: e0.value == null ? null : e0.value as String,
      },
      d: <String, double>{
        for (final MapEntry<String, dynamic> e0 in (json['d'] as Map<String, dynamic>).entries)
          e0.key: e0.value as double,
      },
      e: <String, num>{
        for (final MapEntry<String, dynamic> e0 in (json['e'] as Map<String, dynamic>).entries)
          e0.key: e0.value as num,
      },
      g: <String, bool>{
        for (final MapEntry<String, dynamic> e0 in (json['g'] as Map<String, dynamic>).entries)
          e0.key: e0.value as bool,
      },
    );
  }
}
