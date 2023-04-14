part 'in_1_simple.gen.dart';

@Union()
sealed class AsyncResult {
  const AsyncResult._();

  factory AsyncResult.data() = AsyncResultData;
  factory AsyncResult.error() = AsyncResultError;
}
