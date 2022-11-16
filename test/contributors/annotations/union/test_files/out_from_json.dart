@Union(
  dataClass: false,
  fromJson: true,
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

  /// Creates an instance of [AsyncResult] from [json]
  AsyncResult<T> fromJson(Map<String, dynamic> json) {
// TODO: Implement
    throw UnimplementedError();
  }
}

class AsyncResultError<T> extends AsyncResult<T> {
  const AsyncResultError({
    required this.error,
    this.stackTrace,
  }) : super._();

  final Object error;
  final StackTrace? stackTrace;

  /// Creates an instance of [AsyncResultError] from [json]
  factory AsyncResultError.fromJson(Map<String, dynamic> json) {
    return AsyncResultError<T>(
      error: jsonConverterRegistrant.find(Object).fromJson(json['error']) as Object,
      stackTrace: json['stackTrace'] == null
          ? null
          : jsonConverterRegistrant.find(StackTrace).fromJson(json['stackTrace']) as StackTrace,
    );
  }
}

class AsyncResultLoading<T> extends AsyncResult<T> {
  const AsyncResultLoading() : super._();

  /// Creates an instance of [AsyncResultLoading] from [json]
  factory AsyncResultLoading.fromJson(Map<String, dynamic> json) {
    return AsyncResultLoading<T>();
  }
}

class AsyncResultData<T> extends AsyncResult<T> {
  const AsyncResultData({
    required this.data,
  }) : super._();

  final T data;

  /// Creates an instance of [AsyncResultData] from [json]
  factory AsyncResultData.fromJson(Map<String, dynamic> json) {
    return AsyncResultData<T>(
      data: jsonConverterRegistrant.find(T).fromJson(json['data']) as T,
    );
  }
}
