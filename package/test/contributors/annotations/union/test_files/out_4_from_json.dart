part 'in_4_from_json.gen.dart';

@Union(
  fromJson: true,
)
sealed class AsyncResult {
  const AsyncResult._();

  /// Creates an instance of [AsyncResult] from [json]
  factory AsyncResult.fromJson(Map<dynamic, dynamic> json) => _$AsyncResultFromJson(json);

  factory AsyncResult.data() = AsyncResultData;
  factory AsyncResult.error() = AsyncResultError;
}
