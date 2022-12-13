// AUTO GENERATED - DO NOT MODIFY

part of 'hash_and_equals.dart';

class _$PointImpl extends Point {
  _$PointImpl({
    required this.x,
    required this.y,
  }) : super._();

  @override
  final double x;

  @override
  final double y;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'x': x,
      'y': y,
    };
  }

  @override
  _$PointImpl copyWith({
    final double? x,
    final double? y,
  }) {
    return _$PointImpl(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  @override
  String toString() {
    String value = 'Point{<optimized out>}';
    assert(() {
      value = 'Point@<$hexIdentity>{x: $x, y: $y}';
      return true;
    }());
    return value;
  }
}
