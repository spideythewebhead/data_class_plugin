@Union()
abstract class UnionWithDefaultValues {
  const UnionWithDefaultValues._();

  const factory UnionWithDefaultValues.impl({
    @DefaultValue<String>('') String value2,
    @DefaultValue<int>(0) int value4,
    @DefaultValue<bool>(true) bool value5,
  }) = Impl;

  /// Executes one of the provided callbacks based on a type match
  R when<R>({
    required R Function(Impl value) impl,
  }) {
    if (this is Impl) {
      return impl(this as Impl);
    }
    throw UnimplementedError('Unknown instance of $this used in when(..)');
  }

  /// Executes one of the provided callbacks if a type is matched
  ///
  /// If no match is found [orElse] is executed
  R maybeWhen<R>({
    R Function(Impl value)? impl,
    required R Function() orElse,
  }) {
    if (this is Impl) {
      return impl?.call(this as Impl) ?? orElse();
    }
    throw UnimplementedError('Unknown instance of $this used in maybeWhen(..)');
  }
}

class Impl extends UnionWithDefaultValues {
  const Impl({
    this.value2 = '',
    this.value4 = 0,
    this.value5 = true,
  }) : super._();

  final String value2;
  final int value4;
  final bool value5;

  /// Creates a new instance of [Impl] with optional new values
  Impl copyWith({
    final String? value2,
    final int? value4,
    final bool? value5,
  }) {
    return Impl(
      value2: value2 ?? this.value2,
      value4: value4 ?? this.value4,
      value5: value5 ?? this.value5,
    );
  }

  /// Returns a hash code based on [this] properties
  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      value2,
      value4,
      value5,
    ]);
  }

  /// Compares [this] with [other] on identity, class type, and properties
  /// *with deep comparison on collections*
  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is Impl &&
            runtimeType == other.runtimeType &&
            value2 == other.value2 &&
            value4 == other.value4 &&
            value5 == other.value5;
  }

  /// Returns a string with the properties of [Impl]
  @override
  String toString() {
    String value = 'Impl{<optimized out>}';
    assert(() {
      value = 'Impl@<$hexIdentity>{value2: $value2, value4: $value4, value5: $value5}';
      return true;
    }());
    return value;
  }
}
