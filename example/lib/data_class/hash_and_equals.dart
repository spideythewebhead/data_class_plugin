import 'package:data_class_plugin/data_class_plugin.dart';

part 'hash_and_equals.gen.dart';

@DataClass(
  hashAndEquals: false,
  fromJson: false,
  toJson: true,
  $toString: true,
)
abstract class Point {
  Point._();

  /// Default constructor
  factory Point({
    required double x,
    required double y,
  }) = _$PointImpl;

  double get x;
  double get y;

  /// Converts [Point] to a [Map] json
  Map<String, dynamic> toJson();

  @override
  String toString();

  /// Creates a new instance of [Point] with optional new values
  Point copyWith({
    final double? x,
    final double? y,
  });
}
