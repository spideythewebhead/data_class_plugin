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
class Union {
  /// Shorthand constructor
  const Union({
    this.dataClass,
    this.fromJson,
    this.toJson,
  });

  /// Toggles code generation for toString, copyWith, equals and hashCode
  ///
  /// Defaults to true
  final bool? dataClass;

  /// Toggles code generation for fromJson
  ///
  /// Defaults to false
  final bool? fromJson;

  /// Toggles code generation for toJson
  ///
  /// Defaults to false
  final bool? toJson;
}

/// Default value for a field specific in a union constructor
///
/// ```dart
/// @Union()
/// class AsyncResult<T> {
///   factory AsyncResult.data({
///     @UnionFieldValue<int>(0)
///     required int data,
///   }) = DataAsyncResult; // DataAsyncResult implementation will be generated
/// ```
class UnionFieldValue<T> {
  const UnionFieldValue(this.value);

  final T value;
}
