enum Enumeration {
  value1(),
  value2(),
  value3();

  /// Default constructor of [Enumeration]
  const Enumeration(this.value);

  final String? value;

  /// Creates an instance of [Enumeration] from [json]
  factory Enumeration.fromJson(String? json) {
    return Enumeration.values.firstWhere((Enumeration e) => e.value == json);
  }
}
