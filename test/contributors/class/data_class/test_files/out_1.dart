@DataClass(
  $toString: true,
  copyWith: false,
  hashAndEquals: false,
  fromJson: false,
  toJson: false,
)
class ToStringTest {
  /// Returns a string with the properties of [ToStringTest]
  @override
  String toString() {
    return '''ToStringTest(
)''';
  }
}
