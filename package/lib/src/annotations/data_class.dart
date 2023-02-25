import 'package:meta/meta_meta.dart';

/// Adding this annotation to a class enables it to create common data class functionality
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
/// [constructorName] Name for the default constructor to be used
///
/// If no value is provided (default), then "ctor" will be used
///
/// _Note: This is only available on file generation mode_
/// [unmodifiableCollections] Wraps collections (List, Map, Set) with the relative [unmodifiable] constructor.
///
/// Applies only for file generation mode
///
/// If no value is provided (default), then true is assumed
///
/// If set to false, then the fields of a collection type
/// will be excluded from hashCode implementation so the hashCode result will be stable
///
/// ```dart
/// @DataClass()
/// class User {
///   User.ctor();
/// }
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
    this.constructorName,
    this.unmodifiableCollections,
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

  /// Default constructor name
  ///
  /// If none provided 'ctor' will be used
  final String? constructorName;

  /// If no value is provided (default), then true is assumed
  ///
  /// If set to false, then the fields of a collection type
  /// will be excluded from hashCode implementation so the hashCode result will be stable
  final bool? unmodifiableCollections;
}
