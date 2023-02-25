class Model {
  /// Shorthand constructor
  Model({
    required this.a,
    required this.b,
    this.c,
    required this.d,
    required this.e,
    required this.f,
    required this.aList,
    required this.bList,
    required this.cList,
    required this.dList,
    required this.eList,
    required this.fList,
    required this.aMap,
    required this.bMap,
    required this.cMap,
    required this.dMap,
    required this.eMap,
    required this.fMap,
  });

  final int a;
  final String b;
  final String? c;
  final double d;
  final num e;
  final bool f;

  final List<int> aList;
  final List<String> bList;
  final List<String?> cList;
  final List<double> dList;
  final List<num> eList;
  final List<bool> fList;

  final Map<String, int> aMap;
  final Map<String, String> bMap;
  final Map<String, String?> cMap;
  final Map<String, double> dMap;
  final Map<String, num> eMap;
  final Map<String, bool> fMap;
}
