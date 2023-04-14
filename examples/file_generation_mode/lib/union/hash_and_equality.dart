import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:file_generation_mode/pretty_print.dart';

part 'hash_and_equality.gen.dart';

@Union()
sealed class AsyncResult {
  const AsyncResult._();

  /// Shorthand constructor
  const AsyncResult();

  factory AsyncResult.data(int data) = AsyncResultData;

  factory AsyncResult.listData(List<int> data) = AsyncResultListData;
}

void main() {
  final AsyncResult data1 = AsyncResult.data(11);
  final AsyncResult data1Copy = AsyncResult.data(11);
  final AsyncResult data2 = AsyncResult.data(12);

  prettyPrint('equality <data1 == data1Copy>', data1 == data1Copy);
  prettyPrint('data1 hash code', data1.hashCode);
  prettyPrint('data1Copy hash code', data1Copy.hashCode);

  prettyPrint('equality <data1 == data2>', data1 == data2);
  prettyPrint('data1 hash code', data1.hashCode);
  prettyPrint('data2 hash code', data2.hashCode);

  final AsyncResult listData1 = AsyncResult.listData(<int>[1, 2, 3]);
  final AsyncResult listData1Copy = AsyncResult.listData(<int>[1, 2, 3]);
  final AsyncResult listData2 = AsyncResult.listData(<int>[3, 2, 1]);

  // deep equality
  prettyPrint('Deep equality <listData1 == listData1Copy>', listData1 == listData1Copy);
  prettyPrint('listData1 hash code', listData1.hashCode);
  prettyPrint('listData1Copy hash code', listData1Copy.hashCode);

  // deep equality
  prettyPrint('Deep equality <listData1 == cart2>', listData1 == listData2);
  prettyPrint('listData1 hash code', listData1.hashCode);
  prettyPrint('listData2 hash code', listData2.hashCode);
}
