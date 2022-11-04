// toJson uses .name of the enum
enum Category1 {
  science,
  sports,
  arts,
  financial;

  /// Default constructor of [Category1]
  const Category1();

  /// Converts [Category1] to a json value
  String toJson() => name;
}

// toJson single final field
enum Category2 {
  science(0),
  sports(1000),
  arts(2000),
  financial(3000);

  /// Default constructor of [Category2]
  const Category2(this.value);

  final int value;

  /// Converts [Category2] to a json value
  int toJson() => value;
}
