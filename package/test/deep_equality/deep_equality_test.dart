import 'package:data_class_plugin/src/deep_equality.dart';
import 'package:test/test.dart';

class _NoEqualsOverride {
  _NoEqualsOverride({required this.x, required this.y});

  final double x;
  final double y;
}

class _EqualsOverride {
  _EqualsOverride({required this.x, required this.y});

  final double x;
  final double y;

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[x, y]);
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
          deepEquality(<String, int>{'a': 1}, <String, int>{'a': 1, 'b': 2}),
          equals(false),
        );
        expect(
          deepEquality(<String, int>{'a': 1, 'b': 2}, <String, int>{'a': 1}),
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

      test('have same elements in a different order', () {
        expect(deepEquality(<int>{1, 2, 3}, <int>{3, 1, 2}), equals(true));
      });

      test('are compared with a list that has the same elements', () {
        expect(deepEquality(<int>{1, 2}, <int>[1, 2]), equals(false));
      });

      test('contain equal collections that are different instances', () {
        final Set<Object> a = <Object>{
          <int>[1],
        };
        final Set<Object> b = <Object>{
          <int>[1],
        };

        expect(deepEquality(a, b), equals(true));
      });
    });
  });

  group('deepHash -', () {
    test('lists with equal elements have the same hash', () {
      expect(deepHash(<int>[1, 2]), equals(deepHash(<int>[1, 2])));
    });

    test('lists with a different order have a different hash', () {
      expect(deepHash(<int>[1, 2]), isNot(equals(deepHash(<int>[2, 1]))));
    });

    test('sets with a different order have the same hash', () {
      expect(deepHash(<int>{1, 2, 3}), equals(deepHash(<int>{3, 1, 2})));
    });

    test('maps with a different order have the same hash', () {
      expect(
        deepHash(<String, int>{'a': 1, 'b': 2}),
        equals(deepHash(<String, int>{'b': 2, 'a': 1})),
      );
    });

    test('nested collections with equal content have the same hash', () {
      final Map<String, List<int>> a = <String, List<int>>{
        'a': <int>[1],
      };
      final Map<String, List<int>> b = <String, List<int>>{
        'a': <int>[1],
      };

      expect(deepHash(a), equals(deepHash(b)));
    });

    test('null has a hash', () {
      expect(deepHash(null), equals(null.hashCode));
    });
  });
}
