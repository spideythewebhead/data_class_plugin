import 'package:meta/meta_meta.dart';

/// Implementors of this interface can create union types
///
/// ```dart
/// @Union()
/// class AsyncResult<T> {
///   factory AsyncResult.data({
///     required T data,
///   }) = DataAsyncResult<T>; // DataAsyncResult<T> implementation will be generated
///
///   factory AsyncResult.error({
///     Object? error,
///   }) = ErrorAsyncResult<T>; // ErrorAsyncResult<T> implementation will be generated
/// }
/// ```
@Target(<TargetKind>{TargetKind.classType})
class Union {
  /// Shorthand constructor
  const Union({
    this.copyWith,
    this.hashAndEquals,
    this.$toString,
    this.fromJson,
    this.toJson,
    this.unionJsonKey,
    this.unionFallbackJsonValue,
    this.unmodifiableCollections,
  });

  /// Toggles code generation for copyWith
  ///
  /// Defaults to false
  final bool? copyWith;

  /// Toggles code generation for hash and equals
  ///
  /// Defaults to true
  final bool? hashAndEquals;

  /// Toggles code generation for toString
  ///
  /// Defaults to true
  final bool? $toString;

  /// Toggles code generation for fromJson
  ///
  /// Defaults to false
  final bool? fromJson;

  /// Toggles code generation for toJson
  ///
  /// Defaults to false
  final bool? toJson;

  /// Union key to use for json convertion
  ///
  /// **Applies only to generation mode = file**, for now
  ///
  /// If none provided a method will not be generated
  final String? unionJsonKey;

  /// If no [UnionJsonKeyValue] is matched then use this fallback value
  final String? unionFallbackJsonValue;

  final bool? unmodifiableCollections;
}

class UnionJsonKeyValue {
  const UnionJsonKeyValue(this.key);

  final String key;
}
