part 'in_5_to_json.gen.dart';

@Union(
  toJson: true,
)
sealed class AsyncResult {
  const AsyncResult._();

  factory AsyncResult.data() = AsyncResultData;
  factory AsyncResult.error() = AsyncResultError;

  /// Converts [AsyncResult] to [Map] json
  Map<String, dynamic> toJson();
}
