enum Enumeration {
  value1(),
  value2(),
  value3();

  /// Default constructor of [Enumeration]
  const Enumeration(this.value);

  final String value;

  /// Converts [Enumeration] to a json value
  String toJson() => value;
}
