enum Enumeration {
  value1(),
  value2(),
  value3();

  /// Default constructor of [Enumeration]
  const Enumeration(this.value);

  final int value;

  /// Creates an instance of [Enumeration] from [json]
  factory Enumeration.fromJson(int json) {
    return Enumeration.values.firstWhere((Enumeration e) => e.value == json);
  }
}
