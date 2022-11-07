class ToJsonTest {
  /// Shorthand constructor
  ToJsonTest({
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

  /// Converts [ToJsonTest] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'a': <dynamic>[
        for (final int i0 in a) i0,
      ],
      'b': <dynamic>[
        for (final String i0 in b) i0,
      ],
      'c': <dynamic>[
        for (final String? i0 in c) i0,
      ],
      'd': <dynamic>[
        for (final double i0 in d) i0,
      ],
      'e': <dynamic>[
        for (final num i0 in e) i0,
      ],
      'g': <dynamic>[
        for (final bool i0 in g) i0,
      ],
    };
  }
}
