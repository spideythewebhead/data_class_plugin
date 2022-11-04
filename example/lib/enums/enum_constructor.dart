enum EnumCtor {
  value1(0, 'a'),
  value2(1, 'b'),
  value3(2, 'c');

  /// Default constructor of [EnumCtor]
  const EnumCtor(
    this.a,
    this.b,
  );

  final int a;
  final String b;
}
