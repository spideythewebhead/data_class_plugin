@DataClass(
  fromJson: true,
  hashAndEquals: false,
  copyWith: false,
  $toString: false,
  toJson: false,
)
class FromJsonTest {
  /// Shorthand constructor
  FromJsonTest();

  /// Creates an instance of [FromJsonTest] from [json]
  factory FromJsonTest.fromJson(Map<String, dynamic> json) {
    return FromJsonTest();
  }
}
