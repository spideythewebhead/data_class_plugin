enum Colors {
  red(),
  green(),
  blue();

  /// Default constructor of [Colors]
  const Colors(this.hex);

  final String hex;

  /// Returns a string with the properties of [Colors]
  @override
  String toString() {
    return '''Colors.$name(
  <hex= $hex>,
)''';
  }
}
