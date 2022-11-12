@DataClass(
  toJson: true,
  fromJson: false,
  hashAndEquals: false,
  copyWith: false,
  $toString: false,
)
class ToJsonTest {
  /// Converts [ToJsonTest] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{};
  }
}
