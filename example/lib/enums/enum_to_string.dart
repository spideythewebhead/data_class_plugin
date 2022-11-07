enum Colors {
  red('#FF0000', 0.5),
  green('#008000', 0.7),
  blue('#0000FF', 0.4);

  /// Default constructor of [Colors]
  const Colors(
    this.hex,
    this.opacity,
  );

  final String hex;
  final double opacity;

  /// Returns a string with the properties of [Colors]
  @override
  String toString() {
    return '''Colors.$name(
  <hex= $hex>,
  <opacity= $opacity>,
)''';
  }
}
