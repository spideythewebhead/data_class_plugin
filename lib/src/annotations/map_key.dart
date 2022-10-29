typedef FromJsonConverter = dynamic Function(Map<String, dynamic> json);
typedef ToJsonConverter = dynamic Function(dynamic value);

class MapKey {
  const MapKey({
    this.name,
    this.fromJson,
    this.toJson,
    this.ignore = false,
    // this.unknownEnumValue,
  });

  /// Replaces the field's access name on json
  ///
  /// ```dart
  /// @MapKey(name: '_id')
  /// final String id;
  /// ```
  /// will result into `id = json['_id']` on the generated code
  final String? name;

  /// Custom converter from json value to object
  ///
  /// The function provided must be a top level or a static class function
  ///
  /// ```dart
  /// String customFromJson(Map<String, dynamic> json) {
  ///   return json['id'] ?? json['_id'] ?? '';
  /// }
  ///
  /// class MyClass {
  ///   @MapKey(fromJson: customFromJson)
  ///   final String id;
  /// }
  /// ```
  /// will result into `id = customFromJson(json)` on the generated code
  final FromJsonConverter? fromJson;

  /// Custom converter from json value to object
  ///
  /// The function provided must be a top level or a static class function
  ///
  /// ```dart
  /// String customToJson(String value) {
  ///   return value.isNotEmpty : value : '_';
  /// }
  ///
  /// class MyClass {
  ///   @MapKey(toJson: customToJson)
  ///   final String id;
  /// }
  /// ```
  /// will result into `'id': customToJson(json['id'])` on the generated code
  final ToJsonConverter? toJson;

  /// Ignores adding the field in the from/to json methods
  ///
  /// *Note: Fields that are private or have initializers will be ignored automatically*
  final bool ignore;

  /// **Not supported yet**
  // final Enum? unknownEnumValue;
}
