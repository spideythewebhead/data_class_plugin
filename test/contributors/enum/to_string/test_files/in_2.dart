enum Colors {
  red(),
  green(),
  blue();

  /// Default constructor of [Colors]
  const Colors(this.hex);

  final String hex;
  final String _private;
  String notFinal = 'notFinal';
}

// Should create a [toString] override for [Colors] using the [hex] field
// and ignoring _private and notFinal
