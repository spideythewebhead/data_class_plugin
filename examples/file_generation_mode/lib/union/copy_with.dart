import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:file_generation_mode/pretty_print.dart';

part 'copy_with.gen.dart';

@Union(copyWith: true)
abstract class AsyncResult {
  const AsyncResult._();

  /// Shorthand constructor
  const AsyncResult();

  // a factory can contain both required positional and named argument
  factory AsyncResult.error(
    Object error, {
    StackTrace? stackTrace,
  }) = AsyncResultError;
}

void main(List<String> args) {
  final AsyncResult asyncError = AsyncResult.error(Exception());
  final AsyncResult asyncErrorCopyWithStackTrace =
      (asyncError as AsyncResultError).copyWith.stackTrace(StackTrace.current);

  prettyPrint('async error without stacktrace', asyncError);
  prettyPrint('async error copyWith stacktrace', asyncErrorCopyWithStackTrace);
}
