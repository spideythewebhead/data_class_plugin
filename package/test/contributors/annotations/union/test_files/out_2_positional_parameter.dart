part 'in_2_positional_parameter.gen.dart';

@Union()
sealed class AsyncResult {
  const AsyncResult._();

  factory AsyncResult.data(int data) = AsyncResultData;
  factory AsyncResult.error(Object error) = AsyncResultError;
}
