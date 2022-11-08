class Test {
  /// Shorthand constructor
  Test({
    required this.value,
  });

  final int value;

  /// Returns a hash code based on [this] properties
  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      value,
    ]);
  }

  /// Compares [this] with [other] on identity, class type, and properties
  /// *with deep comparison on collections*
  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is Test && value == other.value;
  }
}

void main() {
  print(Test(value: 0).hashCode == Test(value: 0).hashCode);
}
