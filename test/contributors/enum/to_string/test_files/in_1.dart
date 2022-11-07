enum Colors {
  red(),
  green(),
  blue();

  /// Default constructor of [Colors]
  const Colors(this.hex);

  final String hex;
}

// Should create a [toString] override for [Colors] using the [hex] field
