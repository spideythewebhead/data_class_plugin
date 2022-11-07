enum Enumeration {
  value1(),
  value2(),
  value3();

  /// Default constructor of [Enumeration]
  const Enumeration(this.value);

  final double value;
}

// Generates a [fromJson] method that contains a double field.
