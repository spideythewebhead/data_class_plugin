@Enum(toJson: true)
enum Category {
  science(1),
  finance(2),
  music(3),
  tech(4);

  /// Default constructor of [Category]
  const Category(this.id);

  final int id;

  /// Converts [Category] to a json value
  int toJson() => id;
}
