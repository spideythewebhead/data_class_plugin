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
/// class EnumCategoryConverter implements TypeConverter<Category, String> {
///   const EnumCategoryConverter();
///
///    @override
///    String toJson(Category value) => value.name;
///
///    @override
///    Category fromJson(String value) {
///      return Category.values.firstWhere((c) => c.name == value);
///    }
/// }
///
/// void main() {
///   // register converter
///   typeConverterRegistrant
///     .register(const EnumCategoryConverter());
/// }
/// ```
abstract class TypeConverter<InType, OutType> {
  InType fromJson(OutType value);
  OutType toJson(InType value);
}

class TypeConverterRegistrant {
  final Map<Type, TypeConverter<Object?, Object?>> _converters = <Type, TypeConverter<Object?, Object?>>{};

  void register<InType extends Object, OutType extends Object>(
    TypeConverter<InType, OutType> converter,
  ) {
    _converters[InType] = converter;
  }

  TypeConverter<Object?, Object?> find<InType>(InType type) {
    final TypeConverter<Object?, Object?>? converter = _converters[type];
    if (converter == null) {
      throw Exception('No converter found for $InType');
    }
    return converter;
  }
}

class _UriTypeConverter implements TypeConverter<Uri, String> {
  const _UriTypeConverter();

  @override
  String toJson(Uri value) => value.toString();

  @override
  Uri fromJson(String value) => Uri.parse(value);
}

class _DateTimeTypeConverter implements TypeConverter<DateTime, String> {
  const _DateTimeTypeConverter();

  @override
  String toJson(DateTime value) => value.toIso8601String();

  @override
  DateTime fromJson(String value) => DateTime.parse(value);
}

/// Registrant for adding new converters used by [fromJson] and [toJson]
///
/// see also on how to register a converter [TypeConverter]
final TypeConverterRegistrant typeConverterRegistrant = TypeConverterRegistrant()
  ..register(const _UriTypeConverter())
  ..register(const _DateTimeTypeConverter());
