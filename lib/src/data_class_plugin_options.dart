import 'dart:io' show File;

import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:data_class_plugin/src/extensions.dart';
import 'package:glob/glob.dart';
import 'package:yaml/yaml.dart';

part 'data_class_plugin_options.gen.dart';

@DataClass()
abstract class DataClassPluginOptions {
  const DataClassPluginOptions._();

  /// Default constructor
  const factory DataClassPluginOptions({
    JsonOptions json,
    DataClassOptions dataClass,
  }) = _$DataClassPluginOptionsImpl;

  @DefaultValue(JsonOptions())
  JsonOptions get json;

  @JsonKey(name: 'data_class')
  @DefaultValue(DataClassOptions())
  DataClassOptions get dataClass;

  static Future<DataClassPluginOptions> fromFile(File file) async {
    try {
      final YamlMap yaml = await file.readAsString().then((String value) => loadYaml(value));
      return DataClassPluginOptions.fromJson(yaml);
    } catch (_) {
      return const DataClassPluginOptions();
    }
  }

  /// Creates an instance of [DataClassPluginOptions] from [json]
  factory DataClassPluginOptions.fromJson(Map<dynamic, dynamic> json) =
      _$DataClassPluginOptionsImpl.fromJson;

  @override
  String toString();
}

@DataClass()
abstract class JsonOptions {
  const JsonOptions._();

  /// Default constructor
  const factory JsonOptions({
    String? keyNameConvention,
    Map<String, List<String>> nameConventionGlobs,
  }) = _$JsonOptionsImpl;

  @JsonKey(name: 'key_name_convention')
  String? get keyNameConvention;

  @JsonKey(name: 'key_name_conventions')
  @DefaultValue(<String, List<String>>{})
  Map<String, List<String>> get nameConventionGlobs;

  /// Creates an instance of [JsonOptions] from [json]
  factory JsonOptions.fromJson(Map<dynamic, dynamic> json) = _$JsonOptionsImpl.fromJson;

  @override
  String toString();
}

@DataClass()
abstract class DataClassOptions {
  const DataClassOptions._();

  /// Default constructor
  const factory DataClassOptions({
    Map<String, DataClassOptionConfig> optionsConfig,
  }) = _$DataClassOptionsImpl;

  @JsonKey(name: 'options_config')
  @DefaultValue(<String, DataClassOptionConfig>{})
  Map<String, DataClassOptionConfig> get optionsConfig;

  /// Creates an instance of [DataClassOptions] from [json]
  factory DataClassOptions.fromJson(Map<dynamic, dynamic> json) = _$DataClassOptionsImpl.fromJson;

  bool? _hasGlobMatch(String option, String filePath) {
    final String? isEnabled = optionsConfig[option]
        ?.enabled
        .firstWhereOrNull((String glob) => Glob(glob).matches(filePath));

    if (isEnabled != null) {
      return true;
    }

    final String? isDisabled = optionsConfig[option]
        ?.disabled
        .firstWhereOrNull((String glob) => Glob(glob).matches(filePath));

    if (isDisabled != null) {
      return false;
    }

    return null;
  }

  bool effectiveCopyWith(String filePath) {
    return _hasGlobMatch('copy_with', filePath) ?? optionsConfig['copy_with']?.defaultValue ?? true;
  }

  bool effectiveHashAndEquals(String filePath) {
    return _hasGlobMatch('hash_and_equals', filePath) ??
        optionsConfig['hash_and_equals']?.defaultValue ??
        true;
  }

  bool effectiveToString(String filePath) {
    return _hasGlobMatch('to_string', filePath) ?? optionsConfig['to_string']?.defaultValue ?? true;
  }

  bool effectiveFromJson(String filePath) {
    return _hasGlobMatch('from_json', filePath) ??
        optionsConfig['from_json']?.defaultValue ??
        false;
  }

  bool effectiveToJson(String filePath) {
    return _hasGlobMatch('to_json', filePath) ?? optionsConfig['to_json']?.defaultValue ?? false;
  }

  @override
  String toString();
}

@DataClass()
abstract class DataClassOptionConfig {
  const DataClassOptionConfig._();

  /// Default constructor
  const factory DataClassOptionConfig({
    bool? defaultValue,
    List<String> enabled,
    List<String> disabled,
  }) = _$DataClassOptionConfigImpl;

  @JsonKey(name: 'default')
  bool? get defaultValue;

  @DefaultValue(<String>[])
  List<String> get enabled;

  @DefaultValue(<String>[])
  List<String> get disabled;

  /// Creates an instance of [DataClassOptionConfig] from [json]
  factory DataClassOptionConfig.fromJson(Map<dynamic, dynamic> json) =
      _$DataClassOptionConfigImpl.fromJson;

  @override
  String toString();
}
