import 'package:data_class_plugin/src/json_key_name_convention.dart';
import 'package:meta/meta_meta.dart';

typedef FromJsonConverter<T> = T Function(
  dynamic value,
  Map<dynamic, dynamic> json,
  String keyName,
);
typedef ToJsonConverter<T> = Object? Function(T value);

/// Adding the [JsonKey] annotation to a field makes it customizable
/// when generating fromJson/toJson methods
///
/// Available features
///
/// [name] Replaces the field's access name on json
///
/// [fromJson] Custom converter from json value to object
///
/// [toJson] Custom converter from json value to object
///
/// [ignore] Ignores adding the field in the from/to json methods
///
/// [nameConvention] Transforms the variable name into one of the [nameJsonKeyNameConventionConvention] typing cases

@Target(<TargetKind>{
  TargetKind.field,
  TargetKind.parameter,
  TargetKind.getter,
})
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
  /// String customFromJson(dynamic value, Map<dynamic, dynamic> json, String keyName) {
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
