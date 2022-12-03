enum PluginAnnotations {
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

  const PluginAnnotations(this.name, this.url, this.description);
  final String name;
  final String url;
  final String description;
}

enum DataClassMethods {
  copyWith('copyWith'),
  equals('=='),
  hash('hashCode'),
  $toString('toString'),
  fromJson('fromJson'),
  toJson('toJson');

  const DataClassMethods(this.name);
  final String name;
}
