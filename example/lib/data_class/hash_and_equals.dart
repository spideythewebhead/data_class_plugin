import 'package:data_class_plugin/data_class_plugin.dart';

@DataClass(
  hashAndEquals: false,
  fromJson: false,
  toJson: true,
  $toString: true,
)
class Point {
  /// Shorthand constructor
  Point({
    required this.x,
    required this.y,
  });

  final double x;
  final double y;

  /// Converts [Point] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'x': x,
      'y': y,
    };
  }

  /// Returns a string with the properties of [Point]
  @override
  String toString() {
    String value = 'Point{<optimized out>}';
    assert(() {
      value = 'Point@<$hexIdentity>{x: $x, y: $y}';
      return true;
    }());
    return value;
  }

  /// Creates a new instance of [Point] with optional new values
  Point copyWith({
    final double? x,
    final double? y,
  }) {
    return Point(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
}
