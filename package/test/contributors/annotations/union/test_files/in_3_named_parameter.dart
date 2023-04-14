import 'package:data_class_plugin/data_class_plugin.dart';

@Union()
class AsyncResult {
  factory AsyncResult.data({required int data}) = AsyncResultData;
  factory AsyncResult.error({required Object error}) = AsyncResultError;
}
