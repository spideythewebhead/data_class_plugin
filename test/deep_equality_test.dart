import 'package:data_class_plugin/src/deep_equality.dart';
import 'package:test/test.dart';

class _NoEqualsOverride {
  _NoEqualsOverride({
    required this.x,
    required this.y,
  });

  final double x;
  final double y;
}

class _EqualsOverride {
  _EqualsOverride({
    required this.x,
    required this.y,
  });

  final double x;
  final double y;

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      x,
      y,
    ]);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is _EqualsOverride && x == other.x && y == other.y;
  }
}

void main() {
  group('primary values comparison -', () {
    test('int', () {
      expect(deepEquality(1, 1), equals(true));
      expect(deepEquality(1, 2), equals(false));
    });

    test('double', () {
      expect(deepEquality(1.0, 1.0), equals(true));
      expect(deepEquality(1.0, 2.0), equals(false));
    });

    test('string', () {
      expect(deepEquality('hi', 'hi'), equals(true));
      expect(deepEquality('hi', 'nothi'), equals(false));
    });

    test('int and double', () {
      expect(deepEquality(1, 1.0), equals(true));
      expect(deepEquality(1, 2.0), equals(false));
    });

    test('null', () {
      expect(deepEquality(null, null), equals(true));
      expect(deepEquality(1, null), equals(false));
    });
  });

  group('classes -', () {
    test('class without equals override', () {
      final _NoEqualsOverride a = _NoEqualsOverride(x: 0, y: 0);
      final _NoEqualsOverride b = _NoEqualsOverride(x: 0, y: 0);
      expect(deepEquality(a, b), equals(false));
    });

    test('class with equals override', () {
      final _EqualsOverride a = _EqualsOverride(x: 0, y: 0);
      final _EqualsOverride b = _EqualsOverride(x: 0, y: 0);
      expect(deepEquality(a, b), equals(true));
    });
  });

  group('collections -', () {
    group('lists -', () {
      test('have different length', () {
        expect(deepEquality(<int>[1], <int>[1, 2]), equals(false));
        expect(deepEquality(<int>[1, 2], <int>[1]), equals(false));
      });

      test('have same length, different elements', () {
        expect(deepEquality(<int>[1, 2, 3], <int>[1, 2, 4]), equals(false));
      });

      test('have same length, same elements', () {
        expect(deepEquality(<int>[3, 2, 1], <int>[3, 2, 1]), equals(true));
      });
    });

    group('maps -', () {
      test('have different length', () {
        expect(
          deepEquality(
            <String, int>{'a': 1},
            <String, int>{'a': 1, 'b': 2},
          ),
          equals(false),
        );
        expect(
          deepEquality(
            <String, int>{'a': 1, 'b': 2},
            <String, int>{'a': 1},
          ),
          equals(false),
        );
      });

      test('have same length, different elements', () {
        expect(
          deepEquality(
            <String, int>{'a': 1, 'b': 2},
            <String, int>{'a': 1, 'b': 3},
          ),
          equals(false),
        );
      });

      test('have same length, same elements', () {
        expect(
          deepEquality(
            <String, int>{'a': 1, 'b': 3, 'c': 2},
            <String, int>{'c': 2, 'b': 3, 'a': 1},
          ),
          equals(true),
        );
      });

      test('have missing key', () {
        expect(
          deepEquality(
            <String, int>{'a': 1, 'b': 3, 'c': 2},
            <String, int>{'c': 2, 'b': 3, 'd': 1},
          ),
          equals(false),
        );
      });
    });

    group('sets -', () {
      test('have different length', () {
        expect(deepEquality(<int>{1}, <int>{1, 2}), equals(false));
        expect(deepEquality(<int>{1, 2}, <int>{1}), equals(false));
      });

      test('have same length, different elements', () {
        expect(deepEquality(<int>{1, 2, 3}, <int>[1, 2, 4]), equals(false));
      });

      test('have same length, same elements', () {
        expect(deepEquality(<int>{3, 2, 1}, <int>{3, 2, 1}), equals(true));
      });
    });
  });
}
