typedef FromMapConverter = dynamic Function(Map<String, dynamic> map);
typedef ToMapConverter = dynamic Function(Object? value);

class MapKey {
  const MapKey({
    this.name,
    this.fromMap,
    this.toMap,
    this.ignore = false,
    // this.unknownEnumValue,
  });

  /// Replaces the field's access name on map
  ///
  /// ```dart
  /// @MapKey(name: '_id')
  /// final String id;
  /// ```
  /// will result into `id = map['_id']` on the generated code
  final String? name;

  /// Custom converter from map value to object
  ///
  /// The function provided must be a top level or a static class function
  ///
  /// ```dart
  /// String customFromMap(Map<String, dynamic> map) {
  ///   return map['id'] ?? map['_id'] ?? '';
  /// }
  ///
  /// class MyClass {
  ///   @MapKey(fromMap: customFromMap)
  ///   final String id;
  /// }
  /// ```
  /// will result into `id = customFromMap(map)` on the generated code
  final FromMapConverter? fromMap;

  /// Custom converter from map value to object
  ///
  /// The function provided must be a top level or a static class function
  ///
  /// ```dart
  /// String customToMap(String value) {
  ///   return value.isNotEmpty : value : '_';
  /// }
  ///
  /// class MyClass {
  ///   @MapKey(toMap: customToMap)
  ///   final String id;
  /// }
  /// ```
  /// will result into `'id': customToMap(map['id'])` on the generated code
  final ToMapConverter? toMap;

  /// Ignores adding the field in the from/to map methods
  ///
  /// *Note: Fields that are private or have initializers will be ignored automatically*
  final bool ignore;

  /// **Not supported yet**
  // final Enum? unknownEnumValue;
}
