import 'package:meta/meta.dart' show visibleForTesting;

part 'datetime_converter.dart';
part 'duration_converter.dart';
part 'uri_converter.dart';

/// Interface that custom converters can use to register a convertation between 2 types
///
/// This can be used both for external classes and [Enum] convertions
///
/// ```dart
/// // enum example
/// enum Category {
///   sports,
///   news,
///   celebrity;
/// }
///
/// class EnumCategoryConverter implements JsonConverter<Category, String> {
///   const EnumCategoryConverter();
///
///   @override
///   String toJson(Category value, Map<dynamic, dynamic> json, String keyName) => value.name;
///
///   @override
///   Category fromJson(String value) {
///     return Category.values.firstWhere((c) => c.name == value);
///   }
/// }
///
/// void main() {
///   // register converter
///   jsonConverterRegistrant
///     .register(const EnumCategoryConverter());
/// }
/// ```
abstract class JsonConverter<FieldType, JsonType> {
  FieldType fromJson(
    JsonType value,
    Map<dynamic, dynamic> json,
    String keyName,
  );

  JsonType toJson(FieldType value);
}

class JsonConverterRegistrant {
  final Map<Type, JsonConverter<Object?, Object?>> _converters =
      <Type, JsonConverter<Object?, Object?>>{};

  void register<FieldType extends Object, JsonType extends Object>(
    JsonConverter<FieldType, JsonType> converter,
  ) {
    _converters[FieldType] = converter;
  }

  @visibleForTesting
  void unregister<FieldType extends Object, JsonType extends Object>(
    JsonConverter<FieldType, JsonType> converter,
  ) {
    _converters.removeWhere((_, JsonConverter<Object?, Object?> value) {
      return value == converter;
    });
  }

  JsonConverter<Object?, Object?> find<FieldType>(FieldType type) {
    final JsonConverter<Object?, Object?>? converter = _converters[type];
    if (converter == null) {
      throw Exception("No json converter found for type '$type'");
    }
    return converter;
  }
}

/// Registrant for adding new converters used by [fromJson] and [toJson]
///
/// see also on how to register a converter [JsonConverter]
final JsonConverterRegistrant jsonConverterRegistrant = JsonConverterRegistrant()
  ..register(const _UriJsonConverter())
  ..register(const _DateTimeJsonConverter())
  ..register(const _DurationJsonConverter());
