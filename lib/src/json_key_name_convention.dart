enum JsonKeyNameConvention {
  camelCase(),
  snakeCase(),
  kebabCase(),
  pascalCase();

  /// Default constructor of [JsonKeyNameConvention]
  const JsonKeyNameConvention();

  /// Creates an instance of [JsonKeyNameConvention] from [json]
  factory JsonKeyNameConvention.fromJson(String json) {
    return JsonKeyNameConvention.values
        .firstWhere((JsonKeyNameConvention value) => value.name == json);
  }

  String transform(String key) {
    switch (this) {
      case JsonKeyNameConvention.camelCase:
        return _camelCaseTransform(key);
      case JsonKeyNameConvention.snakeCase:
        return _snakeCaseTransform(key);
      case JsonKeyNameConvention.kebabCase:
        return _kebabCaseTransform(key);
      case JsonKeyNameConvention.pascalCase:
        return _pascalCaseTransform(key);
    }
  }
}

String _camelCaseTransform(String key) => key;

String _snakeCaseTransform(String key) {
  return key.replaceAllMapped(
    RegExp(r'([A-Z]|(\d+))'),
    (Match match) => '_${match.group(1)!.toLowerCase()}',
  );
}

String _kebabCaseTransform(String key) {
  return key.replaceAllMapped(
    RegExp(r'([A-Z]|(\d+))'),
    (Match match) => '-${match.group(1)!.toLowerCase()}',
  );
}

String _pascalCaseTransform(String key) {
  return '${key[0].toUpperCase()}${key.substring(1)}';
}
