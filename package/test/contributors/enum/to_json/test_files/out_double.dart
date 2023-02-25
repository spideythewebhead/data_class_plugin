enum Enumeration {
  value1(),
  value2(),
  value3();

  /// Default constructor of [Enumeration]
  const Enumeration(this.value);

  final double value;

  /// Converts [Enumeration] to a json value
  double toJson() => value;
}
