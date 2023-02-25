// AUTO GENERATED - DO NOT MODIFY

part of 'data_class_plugin_options.dart';

class _$DataClassPluginOptionsImpl extends DataClassPluginOptions {
  const _$DataClassPluginOptionsImpl({
    this.generationMode = CodeGenerationMode.inPlace,
    List<Glob> allowedFilesGenerationPaths = const <Glob>[],
    this.generatedFileLineLength = 80,
    this.json = const JsonOptions(),
    this.dataClass = const DataClassOptions(),
    this.$enum = const EnumOptions(),
    this.union = const UnionOptions(),
  })  : _allowedFilesGenerationPaths = allowedFilesGenerationPaths,
        super.ctor();

  @override
  final CodeGenerationMode generationMode;

  @override
  List<Glob> get allowedFilesGenerationPaths =>
      List<Glob>.unmodifiable(_allowedFilesGenerationPaths);
  final List<Glob> _allowedFilesGenerationPaths;

  @override
  final int generatedFileLineLength;

  @override
  final JsonOptions json;

  @override
  final DataClassOptions dataClass;

  @override
  final EnumOptions $enum;

  @override
  final UnionOptions union;

  factory _$DataClassPluginOptionsImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$DataClassPluginOptionsImpl(
      generationMode: json['generation_mode'] == null
          ? CodeGenerationMode.inPlace
          : CodeGenerationMode.fromJson(json['generation_mode']),
      allowedFilesGenerationPaths: const _AllowedFilesGenerationPathFieldJsonConverter()
          .fromJson(json['file_generation_paths'], json, 'file_generation_paths'),
      generatedFileLineLength: json['generated_file_line_length'] as int? ?? 80,
      json: json['json'] == null ? const JsonOptions() : JsonOptions.fromJson(json['json']),
      dataClass: json['data_class'] == null
          ? const DataClassOptions()
          : DataClassOptions.fromJson(json['data_class']),
      $enum: json['enum'] == null ? const EnumOptions() : EnumOptions.fromJson(json['enum']),
      union: json['union'] == null ? const UnionOptions() : UnionOptions.fromJson(json['union']),
    );
  }

  @override
  Type get runtimeType => DataClassPluginOptions;
}
