@Enum($toString: true)
enum Category {
  science(1),
  finance(2),
  music(3),
  tech(4);

  /// Default constructor of [Category]
  const Category(this.id);

  final int id;

  /// Returns a string with the properties of [Category]
  @override
  String toString() {
    String value = 'Category{<optimized out>}';
    assert(() {
      value = 'Category@<$hexIdentity>{id: $id}';
      return true;
    }());
    return value;
  }
}
