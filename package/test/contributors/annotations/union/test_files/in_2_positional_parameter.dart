import 'package:data_class_plugin/data_class_plugin.dart';

@Union()
class AsyncResult {
  factory AsyncResult.data(int data) = AsyncResultData;
  factory AsyncResult.error(Object error) = AsyncResultError;
}
