class FromJsonTest {
  /// Shorthand constructor
  FromJsonTest({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
  });

  final List<DateTime> a;
  final List<Uri> b;
  final List<Duration> c;
  final List<Enumeration> d;

  /// Creates an instance of [FromJsonTest] from [json]
  factory FromJsonTest.fromJson(Map<String, dynamic> json) {
    return FromJsonTest(
      a: <DateTime>[
        for (final dynamic i0 in (json['a'] as List<dynamic>))
          jsonConverterRegistrant.find(DateTime).fromJson(i0) as DateTime,
      ],
      b: <Uri>[
        for (final dynamic i0 in (json['b'] as List<dynamic>))
          jsonConverterRegistrant.find(Uri).fromJson(i0) as Uri,
      ],
      c: <Duration>[
        for (final dynamic i0 in (json['c'] as List<dynamic>))
          jsonConverterRegistrant.find(Duration).fromJson(i0) as Duration,
      ],
      d: <Enumeration>[
        for (final dynamic i0 in (json['d'] as List<dynamic>))
          jsonConverterRegistrant.find(Enumeration).fromJson(i0) as Enumeration,
      ],
    );
  }
}
