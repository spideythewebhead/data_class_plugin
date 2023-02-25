class Model {
  /// Shorthand constructor
  Model({
    this.a = 0,
    this.b = '',
    this.c,
    this.d = 0.0,
    this.e = 0.0,
    this.f = false,
  });

  final int a;
  final String b;
  final String? c;
  final double d;
  final num e;
  final bool f;
  final int g = 43;
  String h = 'test';
}

// Should create copyWith function that keeps existing default values,
// includes only 'final public fields without an initializer' in the declaration
// and respects nullability on the declared types
