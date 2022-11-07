class FromJsonTest {
  /// Shorthand constructor
  FromJsonTest({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
  });

  final DateTime a;
  final Uri b;
  final Duration c;
  final Enumeration d;

  /// Creates an instance of [FromJsonTest] from [json]
  factory FromJsonTest.fromJson(Map<String, dynamic> json) {
    return FromJsonTest(
      a: jsonConverterRegistrant.find(DateTime).fromJson(json['a']) as DateTime,
      b: jsonConverterRegistrant.find(Uri).fromJson(json['b']) as Uri,
      c: jsonConverterRegistrant.find(Duration).fromJson(json['c']) as Duration,
      d: jsonConverterRegistrant.find(Enumeration).fromJson(json['d']) as Enumeration,
    );
  }
}
