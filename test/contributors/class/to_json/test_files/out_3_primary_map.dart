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

  final Map<String, int> a;
  final Map<String, String> b;
  final Map<String, String?> c;
  final Map<String, double> d;
  final Map<String, num> e;
  final Map<String, bool> g;

  /// Converts [ToJsonTest] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'a': <String, dynamic>{
        for (final MapEntry<String, int> e0 in a.entries) e0.key: e0.value,
      },
      'b': <String, dynamic>{
        for (final MapEntry<String, String> e0 in b.entries) e0.key: e0.value,
      },
      'c': <String, dynamic>{
        for (final MapEntry<String, String?> e0 in c.entries) e0.key: e0.value,
      },
      'd': <String, dynamic>{
        for (final MapEntry<String, double> e0 in d.entries) e0.key: e0.value,
      },
      'e': <String, dynamic>{
        for (final MapEntry<String, num> e0 in e.entries) e0.key: e0.value,
      },
      'g': <String, dynamic>{
        for (final MapEntry<String, bool> e0 in g.entries) e0.key: e0.value,
      },
    };
  }
}
