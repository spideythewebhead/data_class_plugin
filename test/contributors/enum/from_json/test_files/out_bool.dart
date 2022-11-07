enum Enumeration {
  value1(),
  value2(),
  value3();

  /// Default constructor of [Enumeration]
  const Enumeration(this.value);

  final bool value;

  /// Creates an instance of [Enumeration] from [json]
  factory Enumeration.fromJson(bool json) {
    return Enumeration.values.firstWhere((Enumeration e) => e.value == json);
  }
}
