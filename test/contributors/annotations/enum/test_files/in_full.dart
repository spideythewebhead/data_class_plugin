import 'package:data_class_plugin/data_class_plugin.dart';

@Enum(
  toJson: true,
  fromJson: true,
  $toString: true,
)
enum Category {
  science(1),
  finance(2),
  music(3),
  tech(4);

  final int id;
}

// Should generate fromJson(), toJson() & toString()
