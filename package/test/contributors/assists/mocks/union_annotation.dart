import 'package:data_class_plugin/data_class_plugin.dart';

@Union(
  copyWith: true,
  hashAndEquals: true,
  $toString: true,
  fromJson: false,
  toJson: false,
)
class AsyncResult<T> {
  const AsyncResult._();

  const factory AsyncResult.data({
    required T data,
  }) = AsyncResultData<T>;

  const factory AsyncResult.loading() = AsyncResultLoading<T>;

  const factory AsyncResult.error({
    required Object error,
    StackTrace? stackTrace,
  }) = AsyncResultError<T>;

  /// Executes one of the provided callbacks based on a type match
  R when<R>({
    required R Function(AsyncResultData<T> value) data,
    required R Function(AsyncResultLoading<T> value) loading,
    required R Function(AsyncResultError<T> value) error,
  }) {
    if (this is AsyncResultData<T>) {
      return data(this as AsyncResultData<T>);
    }
    if (this is AsyncResultLoading<T>) {
      return loading(this as AsyncResultLoading<T>);
    }
    if (this is AsyncResultError<T>) {
      return error(this as AsyncResultError<T>);
    }
    throw UnimplementedError('Unknown instance of $this used in when(..)');
  }

  /// Executes one of the provided callbacks if a type is matched
  ///
  /// If no match is found [orElse] is executed
  R maybeWhen<R>({
    R Function(AsyncResultData<T> value)? data,
    R Function(AsyncResultLoading<T> value)? loading,
    R Function(AsyncResultError<T> value)? error,
    required R Function() orElse,
  }) {
    if (this is AsyncResultData<T>) {
      return data?.call(this as AsyncResultData<T>) ?? orElse();
    }
    if (this is AsyncResultLoading<T>) {
      return loading?.call(this as AsyncResultLoading<T>) ?? orElse();
    }
    if (this is AsyncResultError<T>) {
      return error?.call(this as AsyncResultError<T>) ?? orElse();
    }
    throw UnimplementedError('Unknown instance of $this used in maybeWhen(..)');
  }
}

class AsyncResultError<T> extends AsyncResult<T> {
  const AsyncResultError({
    required this.error,
    this.stackTrace,
  }) : super._();

  final Object error;
  final StackTrace? stackTrace;

  /// Creates a new instance of [AsyncResultError] with optional new values
  AsyncResultError<T> copyWith({
    final Object? error,
    final StackTrace? stackTrace,
  }) {
    return AsyncResultError<T>(
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
    );
  }

  /// Returns a hash code based on [this] properties
  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      error,
      stackTrace,
    ]);
  }

  /// Compares [this] with [other] on identity, class type, and properties
  /// *with deep comparison on collections*
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AsyncResultError<T> && error == other.error && stackTrace == other.stackTrace;
  }

  /// Returns a string with the properties of [AsyncResultError]
  @override
  String toString() {
    String value = 'AsyncResultError{<optimized out>}';
    assert(() {
      value = 'AsyncResultError<$T>@<$hexIdentity>{error: $error, stackTrace: $stackTrace}';
      return true;
    }());
    return value;
  }
}

class AsyncResultLoading<T> extends AsyncResult<T> {
  const AsyncResultLoading() : super._();

  /// Creates a new instance of [AsyncResultLoading] with optional new values
  AsyncResultLoading<T> copyWith() {
    return AsyncResultLoading<T>();
  }

  /// Returns a hash code based on [this] properties
  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
    ]);
  }

  /// Compares [this] with [other] on identity, class type, and properties
  /// *with deep comparison on collections*
  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is AsyncResultLoading<T>;
  }

  /// Returns a string with the properties of [AsyncResultLoading]
  @override
  String toString() {
    String value = 'AsyncResultLoading{<optimized out>}';
    assert(() {
      value = 'AsyncResultLoading<$T>@<$hexIdentity>{}';
      return true;
    }());
    return value;
  }
}

class AsyncResultData<T> extends AsyncResult<T> {
  const AsyncResultData({
    required this.data,
  }) : super._();

  final T data;

  /// Creates a new instance of [AsyncResultData] with optional new values
  AsyncResultData<T> copyWith({
    final T? data,
  }) {
    return AsyncResultData<T>(
      data: data ?? this.data,
    );
  }

  /// Returns a hash code based on [this] properties
  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      data,
    ]);
  }

  /// Compares [this] with [other] on identity, class type, and properties
  /// *with deep comparison on collections*
  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is AsyncResultData<T> && data == other.data;
  }

  /// Returns a string with the properties of [AsyncResultData]
  @override
  String toString() {
    String value = 'AsyncResultData{<optimized out>}';
    assert(() {
      value = 'AsyncResultData<$T>@<$hexIdentity>{data: $data}';
      return true;
    }());
    return value;
  }
}
