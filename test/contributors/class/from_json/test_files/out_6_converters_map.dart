class FromJsonTest {
  /// Shorthand constructor
  FromJsonTest({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
  });

  final Map<String, DateTime> a;
  final Map<String, Uri> b;
  final Map<String, Duration> c;
  final Map<String, Enumeration> d;

  /// Creates an instance of [FromJsonTest] from [json]
  factory FromJsonTest.fromJson(Map<dynamic, dynamic> json) {
    return FromJsonTest(
      a: <String, DateTime>{
        for (final MapEntry<dynamic, dynamic> e0 in (json['a'] as Map<dynamic, dynamic>).entries)
          e0.key: jsonConverterRegistrant.find(DateTime).fromJson(e0.value) as DateTime,
      },
      b: <String, Uri>{
        for (final MapEntry<dynamic, dynamic> e0 in (json['b'] as Map<dynamic, dynamic>).entries)
          e0.key: jsonConverterRegistrant.find(Uri).fromJson(e0.value) as Uri,
      },
      c: <String, Duration>{
        for (final MapEntry<dynamic, dynamic> e0 in (json['c'] as Map<dynamic, dynamic>).entries)
          e0.key: jsonConverterRegistrant.find(Duration).fromJson(e0.value) as Duration,
      },
      d: <String, Enumeration>{
        for (final MapEntry<dynamic, dynamic> e0 in (json['d'] as Map<dynamic, dynamic>).entries)
          e0.key: jsonConverterRegistrant.find(Enumeration).fromJson(e0.value) as Enumeration,
      },
    );
  }
}
