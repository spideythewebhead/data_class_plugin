part 'in_1_simple.gen.dart';

@Union()
abstract class AsyncResult {
  const AsyncResult._();

  factory AsyncResult.data() = AsyncResultData;
  factory AsyncResult.error() = AsyncResultError;
}
