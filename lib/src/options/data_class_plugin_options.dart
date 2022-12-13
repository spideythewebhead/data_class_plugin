import 'dart:io' as io show File;

import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:data_class_plugin/src/options/data_class_options.dart';
import 'package:data_class_plugin/src/options/enum_options.dart';
import 'package:data_class_plugin/src/options/json_options.dart';
import 'package:data_class_plugin/src/options/union_options.dart';
// import 'package:data_class_plugin/src/options/options.dart';
import 'package:yaml/yaml.dart';

part 'data_class_plugin_options.gen.dart';

@Enum(fromJson: true)
enum CodeGenerationMode {
  inPlace('in_place'),
  file('file');

  /// Default constructor of [CodeGenerationMode]
  const CodeGenerationMode(this.name);

  final String name;

  /// Creates an instance of [CodeGenerationMode] from [json]
  factory CodeGenerationMode.fromJson(String json) {
    return CodeGenerationMode.values.firstWhere((CodeGenerationMode e) => e.name == json);
  }
}

@DataClass()
abstract class DataClassPluginOptions {
  const DataClassPluginOptions._();

  /// Default constructor
  const factory DataClassPluginOptions({
    CodeGenerationMode generationMode,
    JsonOptions json,
    DataClassOptions dataClass,
    EnumOptions $enum,
    UnionOptions union,
  }) = _$DataClassPluginOptionsImpl;

  /// Creates an instance of [DataClassPluginOptions] from [json]
  factory DataClassPluginOptions.fromJson(Map<dynamic, dynamic> json) =
      _$DataClassPluginOptionsImpl.fromJson;

  @DefaultValue(CodeGenerationMode.inPlace)
  CodeGenerationMode get generationMode;

  @DefaultValue(JsonOptions())
  JsonOptions get json;

  @DefaultValue(DataClassOptions())
  DataClassOptions get dataClass;

  @JsonKey(name: 'enum')
  @DefaultValue(EnumOptions())
  EnumOptions get $enum;

  @DefaultValue(UnionOptions())
  UnionOptions get union;

  static Future<DataClassPluginOptions> fromFile(io.File file) async {
    try {
      final YamlMap yaml = await file.readAsString().then((String value) => loadYaml(value));
      return DataClassPluginOptions.fromJson(yaml);
    } catch (_) {
      return const DataClassPluginOptions();
    }
  }
}
