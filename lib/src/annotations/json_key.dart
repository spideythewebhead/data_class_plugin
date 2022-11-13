import 'package:data_class_plugin/src/json_key_name_convention.dart';

typedef FromJsonConverter<T> = T Function(Map<String, dynamic> json);
typedef ToJsonConverter<T> = Object? Function(T value);

class JsonKey<T> {
  const JsonKey({
    this.name,
    this.fromJson,
    this.toJson,
    this.ignore,
    this.nameConvention,
  });

  /// Replaces the field's access name on json
  ///
  /// ```dart
  /// @JsonKey<String>(name: '_id')
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
  ///   @JsonKey<String>(fromJson: customFromJson)
  ///   final String id;
  /// }
  /// ```
  /// will result into `id = customFromJson(json)` on the generated code
  final FromJsonConverter<T>? fromJson;

  /// Custom converter from json value to object
  ///
  /// The function provided must be a top level or a static class function
  ///
  /// ```dart
  /// Object? customToJson(String value) {
  ///   return value.isNotEmpty : value : '_';
  /// }
  ///
  /// class MyClass {
  ///   @JsonKey<String>(toJson: customToJson)
  ///   final String id;
  /// }
  /// ```
  /// will result into `'id': customToJson(json['id'])` on the generated code
  final ToJsonConverter<T>? toJson;

  /// Ignores adding the field in the from/to json methods
  ///
  /// *Note: Fields that are private or have initializers will be ignored automatically*
  ///
  /// If no value is provided (default), then false is assumed
  final bool? ignore;

  /// Transforms the variable name into one of the [nameJsonKeyNameConventionConvention] typing cases
  ///
  /// If no value is provided (default), then [JsonKeyNameConvention.camelCase] is assumed
  final JsonKeyNameConvention? nameConvention;
}
