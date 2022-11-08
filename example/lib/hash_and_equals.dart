import 'package:data_class_plugin/public/deep_equality.dart';

class ClassName {
  ClassName({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.e,
    required this.f,
    required this.g,
  });

  final String a;
  final int b;
  final double c;
  final String? d;
  final List<String> e;
  final Map<String, int> f;
  final Set<Point> g;

  /// Returns a hash code based on [this] properties
  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      a,
      b,
      c,
      d,
      e,
      f,
      g,
    ]);
  }

  /// Compares [this] with [other] on identity, class type, and properties
  /// *with deep comparison on collections*
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ClassName &&
            a == other.a &&
            b == other.b &&
            c == other.c &&
            d == other.d &&
            deepEquality(e, other.e) &&
            deepEquality(f, other.f) &&
            deepEquality(g, other.g);
  }
}

class Point {
  Point({
    required this.x,
    required this.y,
  });

  final double x;
  final double y;

  /// Returns a hash code based on [this] properties
  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      x,
      y,
    ]);
  }

  /// Compares [this] with [other] on identity, class type, and properties
  /// *with deep comparison on collections*
  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is Point && x == other.x && y == other.y;
  }
}
