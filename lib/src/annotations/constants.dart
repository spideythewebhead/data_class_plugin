/// Available Annotations
enum AnnotationType {
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
  unionJsonKeyValue(
    'UnionJsonKeyValue',
    'https://github.com/spideythewebhead/data_class_plugin',
    'Annotates a constructor with the value to use for json convertion',
  ),
  enumeration(
    'Enum',
    'https://github.com/spideythewebhead/data_class_plugin#enum-annotation',
    'Adding this annotation to an enum enables it to create common data class functionality.',
  ),
  jsonKey(
    'JsonKey',
    'https://github.com/spideythewebhead/data_class_plugin',
    'Adding the [JsonKey] annotation to a field makes it customizable when generating fromJson/toJson methods.',
  ),
  defaultValue(
    'DefaultValue',
    'https://github.com/spideythewebhead/data_class_plugin',
    'Provide default for a Data Class field or Union factory parameter.',
  );

  const AnnotationType(
    this.name,
    this.url,
    this.description,
  );

  /// Annotation Name
  final String name;

  /// Documentation url
  final String url;

  /// Short description
  final String description;
}

/// Interface for annotation arguments
abstract class AnnotationArg {
  const AnnotationArg({
    required this.name,
    required this.defaultValue,
  });

  final String name;
  final bool defaultValue;
}

/// Arguments for the [DataClass] annotation
class DataClassAnnotationArg extends AnnotationArg {
  const DataClassAnnotationArg._({
    required super.name,
    required super.defaultValue,
  });

  static const DataClassAnnotationArg copyWith = DataClassAnnotationArg._(
    name: 'copyWith',
    defaultValue: true,
  );

  static const DataClassAnnotationArg equals = DataClassAnnotationArg._(
    name: '==',
    defaultValue: true,
  );

  static const DataClassAnnotationArg hash = DataClassAnnotationArg._(
    name: 'hashCode',
    defaultValue: true,
  );

  static const DataClassAnnotationArg $toString = DataClassAnnotationArg._(
    name: 'toString',
    defaultValue: true,
  );

  static const DataClassAnnotationArg fromJson = DataClassAnnotationArg._(
    name: 'fromJson',
    defaultValue: false,
  );

  static const DataClassAnnotationArg toJson = DataClassAnnotationArg._(
    name: 'toJson',
    defaultValue: false,
  );

  static List<DataClassAnnotationArg> values = <DataClassAnnotationArg>[
    copyWith,
    equals,
    hash,
    $toString,
    fromJson,
    toJson,
  ];
}

/// Arguments for the [Enum] annotation
class EnumAnnotationArg extends AnnotationArg {
  const EnumAnnotationArg._({
    required super.name,
    required super.defaultValue,
  });

  static const EnumAnnotationArg $toString = EnumAnnotationArg._(
    name: 'toString',
    defaultValue: true,
  );

  static const EnumAnnotationArg fromJson = EnumAnnotationArg._(
    name: 'fromJson',
    defaultValue: false,
  );

  static const EnumAnnotationArg toJson = EnumAnnotationArg._(
    name: 'toJson',
    defaultValue: false,
  );

  static List<EnumAnnotationArg> values = <EnumAnnotationArg>[
    $toString,
    fromJson,
    toJson,
  ];
}

/// Arguments for the [Union] annotation
class UnionAnnotationArg extends AnnotationArg {
  const UnionAnnotationArg._({
    required super.name,
    required super.defaultValue,
  });

  static const UnionAnnotationArg dataClass = UnionAnnotationArg._(
    name: 'dataClass',
    defaultValue: true,
  );

  static const UnionAnnotationArg fromJson = UnionAnnotationArg._(
    name: 'fromJson',
    defaultValue: false,
  );

  static const UnionAnnotationArg toJson = UnionAnnotationArg._(
    name: 'toJson',
    defaultValue: false,
  );

  static List<UnionAnnotationArg> values = <UnionAnnotationArg>[
    dataClass,
    fromJson,
    toJson,
  ];
}
