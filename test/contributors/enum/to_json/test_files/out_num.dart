enum Enumeration {
  value1(),
  value2(),
  value3();

  /// Default constructor of [Enumeration]
  const Enumeration(this.value);

  final num value;

  /// Converts [Enumeration] to a json value
  num toJson() => value;
}
