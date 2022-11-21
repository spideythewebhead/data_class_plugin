import 'package:data_class_plugin/data_class_plugin.dart';

part 'data_class.gen.dart';

@Union(dataClass: true)
abstract class AsyncResult<T> {
  /// Creates an instance of [AsyncResult] from [json]
  factory AsyncResult.fromJson(Map<dynamic, dynamic> json) {
    throw UnimplementedError();
  }

  const AsyncResult._();

  const factory AsyncResult.data({
    required T data,
  }) = AsyncResultData<T>;

  const factory AsyncResult.loading() = AsyncResultLoading<T>;

  const factory AsyncResult.error({
    required Object error,
    StackTrace? stackTrace,
  }) = AsyncResultError<T>;

  /// Converts [AsyncResult] to [Map] json
  Map<String, dynamic> toJson();

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
