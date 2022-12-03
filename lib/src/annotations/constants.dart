import 'package:analyzer/dart/ast/ast.dart';

class PluginAnnotation {
  /// Shorthand constructor
  PluginAnnotation({
    required this.type,
    required this.annotation,
  });

  final AnnotationTypes type;
  final Annotation annotation;
}

enum AnnotationTypes {
  dataClass(
    'DataClass',
    'https://github.com/spideythewebhead/data_class_plugin#dataclass-annotation',
    'Adding this annotation to a class enables it to create common data class functionality.',
  ),
  union(
    'Union',
    'https://github.com/spideythewebhead/data_class_plugin#union-annotation',
    'Implementors of this interface can create union types.',
  ),
  enumeration(
    'Enum',
    'https://github.com/spideythewebhead/data_class_plugin#enum-annotation',
    'Adding this annotation to an enum enables it to create common data class functionality.',
  ),
  unionFieldValue(
    'UnionFieldValue',
    '',
    '',
  ),
  jsonKey(
    'JsonKey',
    '',
    'Adding the [JsonKey] annotation to a field makes it customizable when generating fromJson/toJson methods.',
  );

  const AnnotationTypes(this.name, this.url, this.description);
  final String name;
  final String url;
  final String description;
}

abstract class AnnotationArgs {
  const AnnotationArgs({
    required this.name,
    required this.defaultValue,
  });

  final String name;
  final bool defaultValue;
}

class DataClassAnnotationArgs extends AnnotationArgs {
  const DataClassAnnotationArgs._({
    required super.name,
    required super.defaultValue,
  });

  static const DataClassAnnotationArgs copyWith = DataClassAnnotationArgs._(
    name: 'copyWith',
    defaultValue: true,
  );

  static const DataClassAnnotationArgs equals = DataClassAnnotationArgs._(
    name: '==',
    defaultValue: true,
  );

  static const DataClassAnnotationArgs hash = DataClassAnnotationArgs._(
    name: 'hashCode',
    defaultValue: true,
  );

  static const DataClassAnnotationArgs $toString = DataClassAnnotationArgs._(
    name: 'toString',
    defaultValue: true,
  );

  static const DataClassAnnotationArgs fromJson = DataClassAnnotationArgs._(
    name: 'fromJson',
    defaultValue: false,
  );

  static const DataClassAnnotationArgs toJson = DataClassAnnotationArgs._(
    name: 'toJson',
    defaultValue: false,
  );

  static List<DataClassAnnotationArgs> values = <DataClassAnnotationArgs>[
    copyWith,
    equals,
    hash,
    $toString,
    fromJson,
    toJson,
  ];
}

class EnumAnnotationArgs extends AnnotationArgs {
  const EnumAnnotationArgs._({
    required super.name,
    required super.defaultValue,
  });

  static const EnumAnnotationArgs $toString = EnumAnnotationArgs._(
    name: 'toString',
    defaultValue: true,
  );

  static const EnumAnnotationArgs fromJson = EnumAnnotationArgs._(
    name: 'fromJson',
    defaultValue: false,
  );

  static const EnumAnnotationArgs toJson = EnumAnnotationArgs._(
    name: 'toJson',
    defaultValue: false,
  );

  static List<EnumAnnotationArgs> values = <EnumAnnotationArgs>[
    $toString,
    fromJson,
    toJson,
  ];
}

class UnionAnnotationArgs extends AnnotationArgs {
  const UnionAnnotationArgs._({
    required super.name,
    required super.defaultValue,
  });

  static const UnionAnnotationArgs dataClass = UnionAnnotationArgs._(
    name: 'dataClass',
    defaultValue: true,
  );

  static const UnionAnnotationArgs fromJson = UnionAnnotationArgs._(
    name: 'fromJson',
    defaultValue: false,
  );

  static const UnionAnnotationArgs toJson = UnionAnnotationArgs._(
    name: 'toJson',
    defaultValue: false,
  );

  static List<UnionAnnotationArgs> values = <UnionAnnotationArgs>[
    dataClass,
    fromJson,
    toJson,
  ];
}
