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
///   String toJson(Category value) => value.name;
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
abstract class JsonConverter<InType, OutType> {
  InType fromJson(OutType value);
  OutType toJson(InType value);
}

class JsonConverterRegistrant {
  final Map<Type, JsonConverter<Object?, Object?>> _converters =
      <Type, JsonConverter<Object?, Object?>>{};

  void register<InType extends Object, OutType extends Object>(
    JsonConverter<InType, OutType> converter,
  ) {
    _converters[InType] = converter;
  }

  JsonConverter<Object?, Object?> find<InType>(InType type) {
    final JsonConverter<Object?, Object?>? converter = _converters[type];
    if (converter == null) {
      throw Exception('No json converter found for $InType');
    }
    return converter;
  }
}

class _UriJsonConverter implements JsonConverter<Uri, String> {
  const _UriJsonConverter();

  @override
  String toJson(Uri value) => value.toString();

  @override
  Uri fromJson(String value) => Uri.parse(value);
}

class _DateTimeJsonConverter implements JsonConverter<DateTime, String> {
  const _DateTimeJsonConverter();

  @override
  String toJson(DateTime value) => value.toIso8601String();

  @override
  DateTime fromJson(String value) => DateTime.parse(value);
}

/// Registrant for adding new converters used by [fromJson] and [toJson]
///
/// see also on how to register a converter [JsonConverter]
final JsonConverterRegistrant jsonConverterRegistrant = JsonConverterRegistrant()
  ..register(const _UriJsonConverter())
  ..register(const _DateTimeJsonConverter());
