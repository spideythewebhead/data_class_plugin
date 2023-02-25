enum Enumeration {
  value1(),
  value2(),
  value3();

  /// Default constructor of [Enumeration]
  const Enumeration(this.value);

  final int value;
}

// Generates a [toJson] method that contains an int field.
