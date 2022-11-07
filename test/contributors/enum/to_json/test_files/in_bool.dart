enum Enumeration {
  value1(),
  value2(),
  value3();

  /// Default constructor of [Enumeration]
  const Enumeration(this.value);

  final bool value;
}

// Generates a [toJson] method that contains a bool field.
