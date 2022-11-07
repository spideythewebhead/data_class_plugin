class FromJsonTest {
  final DateTime a;
  final Uri b;
  final Duration c;
  final Enumeration d;

  final DateTime aList;
  final Uri bList;
  final Duration cList;
  final Enumeration dList;

  final DateTime aMap;
  final Uri bMap;
  final Duration cMap;
  final Enumeration dMap;
}

enum Enumeration {
  value1,
  value2,
  value3,
  value4,
  value5;
}

// Should create a constructor that includes the default json converters
