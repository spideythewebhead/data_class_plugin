import 'dart:io' as io show File;

import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:data_class_plugin/src/options/options.dart';
import 'package:yaml/yaml.dart';

@DataClass()
class DataClassPluginOptions {
  /// Shorthand constructor
  const DataClassPluginOptions({
    this.json = const JsonOptions(),
    this.dataClass = const DataClassOptions(),
    this.$enum = const EnumOptions(),
  });

  final JsonOptions json;
  final DataClassOptions dataClass;
  @JsonKey(name: 'enum')
  final EnumOptions $enum;

  static Future<DataClassPluginOptions> fromFile(io.File file) async {
    try {
      final YamlMap yaml = await file.readAsString().then((String value) => loadYaml(value));
      return DataClassPluginOptions.fromJson(yaml);
    } catch (_) {
      return const DataClassPluginOptions();
    }
  }

  /// Creates an instance of [DataClassPluginOptions] from [json]
  factory DataClassPluginOptions.fromJson(Map<dynamic, dynamic> json) {
    return DataClassPluginOptions(
      json: json['json'] == null ? const JsonOptions() : JsonOptions.fromJson(json['json']),
      dataClass: json['data_class'] == null
          ? const DataClassOptions()
          : DataClassOptions.fromJson(json['data_class']),
      $enum: json['enum'] == null ? const EnumOptions() : EnumOptions.fromJson(json['enum']),
    );
  }
}
