import 'package:meta/meta_meta.dart';

/// Adding this annotation to an enum enables it to create common data class functionality
///
/// Available methods are
///
/// [$toString] Implements toString method
///
/// If no value is provided (default), then true is assumed
///
/// ```dart
/// String toString()
/// ```
///
/// [fromJson] Generates a factory constructor that creates a new instance from a Map
///
/// If no value is provided (default), then false is assumed
///
/// ```dart
/// factory YourClass.fromJson(Map<dynamic, dynamic> json)
/// ```
///
/// [toJson] Generates a function that coverts this instance to a Map
///
/// If no value is provided (default), then false is assumed
///
/// ```dart
/// Map<String, dynamic> toJson()
/// ```
@Target(<TargetKind>{TargetKind.enumType})
class Enum {
  /// Shorthand constructor
  const Enum({
    this.$toString,
    this.fromJson,
    this.toJson,
  });

  /// If no value is provided (default), then true is assumed
  final bool? $toString;

  /// If no value is provided (default), then false is assumed
  final bool? fromJson;

  /// If no value is provided (default), then false is assumed
  final bool? toJson;
}
