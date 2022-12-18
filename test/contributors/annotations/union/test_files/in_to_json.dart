import 'package:data_class_plugin/data_class_plugin.dart';

@Union(
  copyWith: false,
  hashAndEquals: false,
  $toString: false,
  fromJson: false,
  toJson: true,
)
class AsyncResult<T> {
  const factory AsyncResult.data({
    required T data,
  }) = AsyncResultData<T>;

  const factory AsyncResult.loading() = AsyncResultLoading<T>;

  const factory AsyncResult.error({
    required Object error,
    StackTrace? stackTrace,
  }) = AsyncResultError<T>;
}
