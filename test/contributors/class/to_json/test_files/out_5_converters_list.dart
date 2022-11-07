class ToJsonTest {
  /// Shorthand constructor
  ToJsonTest({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
  });

  final List<DateTime> a;
  final List<Uri> b;
  final List<Duration> c;
  final List<Enumeration> d;

  /// Converts [ToJsonTest] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'a': <dynamic>[
        for (final DateTime i0 in a) jsonConverterRegistrant.find(DateTime).toJson(i0),
      ],
      'b': <dynamic>[
        for (final Uri i0 in b) jsonConverterRegistrant.find(Uri).toJson(i0),
      ],
      'c': <dynamic>[
        for (final Duration i0 in c) jsonConverterRegistrant.find(Duration).toJson(i0),
      ],
      'd': <dynamic>[
        for (final Enumeration i0 in d) jsonConverterRegistrant.find(Enumeration).toJson(i0),
      ],
    };
  }
}
