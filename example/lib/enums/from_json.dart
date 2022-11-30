// fromJson uses .name of the enum
enum Category1 {
  science,
  sports,
  arts,
  financial;

  /// Default constructor of [Category1]
  const Category1();

  /// Creates an instance of [Category1] from [json]
  factory Category1.fromJson(String json) {
    return Category1.values.firstWhere((Category1 value) => value.name == json);
  }
}

// fromJson single final field
enum Category2 {
  science(0),
  sports(1000),
  arts(2000),
  financial(3000);

  /// Default constructor of [Category2]
  const Category2(this.value);

  final int value;

  /// Creates an instance of [Category2] from [json]
  factory Category2.fromJson(int json) {
    return Category2.values.firstWhere((Category2 e) => e.value == json);
  }
}
