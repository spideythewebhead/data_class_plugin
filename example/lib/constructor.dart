class Ctor {
  /// Shorthand constructor
  const Ctor({
    required this.a,
    this.b,
  });

  final int a;
  final String? b;
  final String c = 'c';
}
