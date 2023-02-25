@DataClass(
  $toString: true,
  copyWith: false,
  hashAndEquals: false,
  fromJson: false,
  toJson: false,
)
class ToStringTest {
  /// Shorthand constructor
  ToStringTest();

  /// Returns a string with the properties of [ToStringTest]
  @override
  String toString() {
    String value = 'ToStringTest{<optimized out>}';
    assert(() {
      value = 'ToStringTest@<$hexIdentity>{}';
      return true;
    }());
    return value;
  }
}
