class ToJsonTest {
  /// Shorthand constructor
  ToJsonTest({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
  });

  final Map<String, DateTime> a;
  final Map<String, Uri> b;
  final Map<String, Duration> c;
  final Map<String, Enumeration> d;

  /// Converts [ToJsonTest] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'a': <String, dynamic>{
        for (final MapEntry<String, DateTime> e0 in a.entries)
          e0.key: jsonConverterRegistrant.find(DateTime).toJson(e0.value),
      },
      'b': <String, dynamic>{
        for (final MapEntry<String, Uri> e0 in b.entries)
          e0.key: jsonConverterRegistrant.find(Uri).toJson(e0.value),
      },
      'c': <String, dynamic>{
        for (final MapEntry<String, Duration> e0 in c.entries)
          e0.key: jsonConverterRegistrant.find(Duration).toJson(e0.value),
      },
      'd': <String, dynamic>{
        for (final MapEntry<String, Enumeration> e0 in d.entries)
          e0.key: jsonConverterRegistrant.find(Enumeration).toJson(e0.value),
      },
    };
  }
}
