@DataClass(
  copyWith: true,
  $toString: false,
  hashAndEquals: false,
  fromJson: false,
  toJson: false,
)
class CopyWithTest {
  /// Shorthand constructor
  CopyWithTest();

  /// Creates a new instance of [CopyWithTest] with optional new values
  CopyWithTest copyWith() {
    return CopyWithTest();
  }
}
