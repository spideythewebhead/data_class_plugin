enum Enumeration {
  value1(),
  value2(),
  value3();

  /// Default constructor of [Enumeration]
  const Enumeration(this.value);

  final String? value;
}

// Generates a [fromJson] method that contains a nullable field.
