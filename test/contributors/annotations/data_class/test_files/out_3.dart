@DataClass(
  hashAndEquals: true,
  copyWith: false,
  $toString: false,
  fromJson: false,
  toJson: false,
)
class HashAndEqualsTest {
  /// Shorthand constructor
  HashAndEqualsTest();

  /// Returns a hash code based on [this] properties
  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
    ]);
  }

  /// Compares [this] with [other] on identity, class type, and properties
  /// *with deep comparison on collections*
  @override
  bool operator ==(Object? other) {
    return identical(this, other) || other is HashAndEqualsTest && runtimeType == other.runtimeType;
  }
}
