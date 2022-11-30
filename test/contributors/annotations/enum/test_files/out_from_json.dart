@Enum(fromJson: true)
enum Category {
  science(1),
  finance(2),
  music(3),
  tech(4);

  /// Default constructor of [Category]
  const Category(this.id);

  final int id;

  /// Creates an instance of [Category] from [json]
  factory Category.fromJson(int json) {
    return Category.values.firstWhere((Category e) => e.id == json);
  }
}
