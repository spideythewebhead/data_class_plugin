import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:file_generation_mode/pretty_print.dart';

part 'simple.gen.dart';

@Union()
abstract class AsyncResult {
  const AsyncResult._();

  /// Shorthand constructor
  const AsyncResult();

  const factory AsyncResult.loading() = AsyncResultLoading;

  factory AsyncResult.data(int data) = AsyncResultData;

  // a factory can contain both required positional and named argument
  factory AsyncResult.error(
    Object error, {
    StackTrace? stackTrace,
  }) = AsyncResultError;
}

void main() {
  final AsyncResult asyncResultData = AsyncResult.data(11); // or AsyncResultData(11);
  const AsyncResult asyncResultLoading = AsyncResult.loading(); // or AsyncResultData(11);
  final AsyncResult asyncResultError = AsyncResult.error(
    Exception('custom exception'),
    stackTrace: StackTrace.current,
  ); // or AsyncResultError(...);

  prettyPrint('async result data', asyncResultData);
  prettyPrint('async result loading', asyncResultLoading);
  prettyPrint('async result error', asyncResultError);

  // using when as a "switch" case based on type
  asyncResultData.when(
    loading: () => prettyPrint('when => loading', ''),
    data: (AsyncResultData result) => prettyPrint('when => data', result.data),
    error: (AsyncResultError result) => prettyPrint('when => error', result.error),
  );
}
