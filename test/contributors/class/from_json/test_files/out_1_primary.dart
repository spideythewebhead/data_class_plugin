class FromJsonTest {
  /// Shorthand constructor
  FromJsonTest({
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

  /// Creates an instance of [FromJsonTest] from [json]
  factory FromJsonTest.fromJson(Map<dynamic, dynamic> json) {
    return FromJsonTest(
      a: json['a'] as int,
      b: json['b'] as String,
      c: json['c'] == null ? null : json['c'] as String,
      d: json['d'] as double,
      e: json['e'] as num,
      g: json['g'] as bool,
    );
  }
}
