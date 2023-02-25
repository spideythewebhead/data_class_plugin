enum Enumeration {
  value1(),
  value2(),
  value3();

  /// Converts [Enumeration] to a json value
  String toJson() => name;
}
