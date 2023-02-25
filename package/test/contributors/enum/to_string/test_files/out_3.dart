enum Colors {
  red,
  green,
  blue;

  /// Returns a string with the properties of [Colors]
  @override
  String toString() {
    String value = 'Colors{<optimized out>}';
    assert(() {
      value = 'Colors.$name@<$hexIdentity>{}';
      return true;
    }());
    return value;
  }
}
