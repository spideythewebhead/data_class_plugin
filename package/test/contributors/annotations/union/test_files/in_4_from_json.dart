import 'package:data_class_plugin/data_class_plugin.dart';

@Union(
  fromJson: true,
)
class AsyncResult {
  factory AsyncResult.data() = AsyncResultData;
  factory AsyncResult.error() = AsyncResultError;
}
