enum Enumeration {
  value1(),
  value2(),
  value3();

  /// Creates an instance of [Enumeration] from [json]
  factory Enumeration.fromJson(String json) {
    return Enumeration.values.firstWhere((Enumeration value) => value.name == json);
  }
}
