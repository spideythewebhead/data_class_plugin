@Union(
  copyWith: false,
  hashAndEquals: false,
  $toString: false,
  fromJson: false,
  toJson: true,
)
abstract class AsyncResult<T> {
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
    required R Function() loading,
    required R Function(AsyncResultError<T> value) error,
  }) {
    if (this is AsyncResultData<T>) {
      return data(this as AsyncResultData<T>);
    }
    if (this is AsyncResultLoading<T>) {
      return loading();
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
    R Function()? loading,
    R Function(AsyncResultError<T> value)? error,
    required R Function() orElse,
  }) {
    if (this is AsyncResultData<T>) {
      return data?.call(this as AsyncResultData<T>) ?? orElse();
    }
    if (this is AsyncResultLoading<T>) {
      return loading?.call() ?? orElse();
    }
    if (this is AsyncResultError<T>) {
      return error?.call(this as AsyncResultError<T>) ?? orElse();
    }
    throw UnimplementedError('Unknown instance of $this used in maybeWhen(..)');
  }

  /// Converts [AsyncResult] to [Map] json
  Map<String, dynamic> toJson();
}

class AsyncResultData<T> extends AsyncResult<T> {
  const AsyncResultData({
    required this.data,
  }) : super._();

  final T data;

  /// Converts [AsyncResultData] to a [Map] json
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'data': jsonConverterRegistrant.find(T).toJson(data),
    };
  }
}

class AsyncResultLoading<T> extends AsyncResult<T> {
  const AsyncResultLoading() : super._();

  /// Converts [AsyncResultLoading] to a [Map] json
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{};
  }
}

class AsyncResultError<T> extends AsyncResult<T> {
  const AsyncResultError({
    required this.error,
    this.stackTrace,
  }) : super._();

  final Object error;
  final StackTrace? stackTrace;

  /// Converts [AsyncResultError] to a [Map] json
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'error': jsonConverterRegistrant.find(Object).toJson(error),
      'stackTrace':
          stackTrace == null ? null : jsonConverterRegistrant.find(StackTrace).toJson(stackTrace),
    };
  }
}
