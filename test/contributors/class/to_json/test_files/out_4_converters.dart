class ToJsonTest {
  /// Shorthand constructor
  ToJsonTest({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
  });

  final DateTime a;
  final Uri b;
  final Duration c;
  final Enumeration d;

  /// Converts [ToJsonTest] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'a': jsonConverterRegistrant.find(DateTime).toJson(a),
      'b': jsonConverterRegistrant.find(Uri).toJson(b),
      'c': jsonConverterRegistrant.find(Duration).toJson(c),
      'd': jsonConverterRegistrant.find(Enumeration).toJson(d),
    };
  }
}
