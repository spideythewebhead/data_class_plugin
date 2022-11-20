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

  final List<int> a;
  final List<String> b;
  final List<String?> c;
  final List<double> d;
  final List<num> e;
  final List<bool> g;

  /// Creates an instance of [FromJsonTest] from [json]
  factory FromJsonTest.fromJson(Map<dynamic, dynamic> json) {
    return FromJsonTest(
      a: <int>[
        for (final dynamic i0 in (json['a'] as List<dynamic>)) i0 as int,
      ],
      b: <String>[
        for (final dynamic i0 in (json['b'] as List<dynamic>)) i0 as String,
      ],
      c: <String?>[
        for (final dynamic i0 in (json['c'] as List<dynamic>)) i0 == null ? null : i0 as String,
      ],
      d: <double>[
        for (final dynamic i0 in (json['d'] as List<dynamic>)) i0 as double,
      ],
      e: <num>[
        for (final dynamic i0 in (json['e'] as List<dynamic>)) i0 as num,
      ],
      g: <bool>[
        for (final dynamic i0 in (json['g'] as List<dynamic>)) i0 as bool,
      ],
    );
  }
}
