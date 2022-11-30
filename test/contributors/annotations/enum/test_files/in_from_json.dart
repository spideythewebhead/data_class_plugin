import 'package:data_class_plugin/data_class_plugin.dart';

@Enum(fromJson: true)
enum Category {
  science(1),
  finance(2),
  music(3),
  tech(4);

  /// Default constructor of [Category]
  const Category(this.id);

  final int id;
}

// Should generate fromJson()
