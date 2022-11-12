import 'package:meta/meta_meta.dart';

/// Adding this annotation to class enables it to create common data class functionality
///
/// Available methods are
///
/// [copyWith] Generates a new instance of the class with optionally provide new fields values
///
/// If no value is provided (default), then true is assumed
///
/// ```dart
/// YourClass copyWith(...)
/// ```
///
/// [hashAndEquals] Implements hashCode and equals methods
///
/// If no value is provided (default), then true is assumed
///
/// ```dart
/// @override
/// bool operator ==(Object other)
///
/// @override
/// int get hashCode
/// ```
///
/// [$toString] Implements toString method
///
/// If no value is provided (default), then true is assumed
///
/// ```dart
/// String toString()
/// ```
///
/// [fromJson] Generates a factory consturctor that creates a new instance from a Map
///
/// If no value is provided (default), then false is assumed
///
/// ```dart
/// factory YourClass.fromJson(Map<String, dynamic> json)
/// ```
///
/// [toJson] Generates a function that coverts this instance to a Map
///
/// If no value is provided (default), then false is assumed
///
/// ```dart
/// Map<String, dynamic> toJson()
/// ```
@Target(<TargetKind>{TargetKind.classType})
class DataClass {
  /// Shorthand constructor
  const DataClass({
    this.copyWith,
    this.hashAndEquals,
    this.$toString,
    this.fromJson,
    this.toJson,
  });

  /// If no value is provided (default), then true is assumed
  final bool? copyWith;

  /// If no value is provided (default), then true is assumed
  final bool? hashAndEquals;

  /// If no value is provided (default), then true is assumed
  final bool? $toString;

  /// If no value is provided (default), then false is assumed
  final bool? fromJson;

  /// If no value is provided (default), then false is assumed
  final bool? toJson;
}
