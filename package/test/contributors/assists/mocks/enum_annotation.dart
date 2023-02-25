import 'package:data_class_plugin/data_class_plugin.dart';

@Enum()
enum Category {
  science('1'),
  finance('2'),
  sports('3'),
  music('4'),
  movies('5');

  /// Default constructor of [Category]
  const Category(this.id);

  final String id;
}
