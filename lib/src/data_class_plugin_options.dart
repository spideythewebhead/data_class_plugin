import 'dart:convert';
import 'dart:io' as io show File;

import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:data_class_plugin/src/extensions.dart';
import 'package:glob/glob.dart';
import 'package:yaml/yaml.dart';

@DataClass()
class DataClassPluginOptions {
  /// Shorthand constructor
  const DataClassPluginOptions({
    this.json = const JsonOptions(),
    this.dataClass = const DataClassOptions(),
  });

  final JsonOptions json;
  final DataClassOptions dataClass;

  static Future<DataClassPluginOptions> fromFile(io.File file) async {
    try {
      final YamlMap yaml = await file.readAsString().then((String value) => loadYaml(value));
      // workaround to convert YamlMap to Map<String, dynamic>
      final Map<String, dynamic> json = jsonDecode(jsonEncode(yaml));
      return DataClassPluginOptions.fromJson(json);
    } catch (_) {
      return const DataClassPluginOptions();
    }
  }

  /// Creates an instance of [DataClassPluginOptions] from [json]
  factory DataClassPluginOptions.fromJson(Map<String, dynamic> json) {
    return DataClassPluginOptions(
      json: json['json'] == null ? const JsonOptions() : JsonOptions.fromJson(json['json']),
      dataClass: json['data_class'] == null
          ? const DataClassOptions()
          : DataClassOptions.fromJson(json['data_class']),
    );
  }

  /// Returns a string with the properties of [DataClassPluginOptions]
  @override
  String toString() {
    return '''DataClassPluginOptions(
  <json= $json>,
  <dataClass= $dataClass>,
)''';
  }
}

@DataClass()
class JsonOptions {
  /// Shorthand constructor
  const JsonOptions({
    this.keyNameConvention,
    this.nameConventionGlobs = const <String, List<String>>{},
  });

  final String? keyNameConvention;

  @JsonKey(name: 'key_name_conventions')
  final Map<String, List<String>> nameConventionGlobs;

  /// Creates an instance of [JsonOptions] from [json]
  factory JsonOptions.fromJson(Map<String, dynamic> json) {
    return JsonOptions(
      keyNameConvention:
          json['key_name_convention'] == null ? null : json['key_name_convention'] as String,
      nameConventionGlobs: json['key_name_conventions'] == null
          ? const <String, List<String>>{}
          : <String, List<String>>{
              for (final MapEntry<String, dynamic> e0
                  in (json['key_name_conventions'] as Map<String, dynamic>).entries)
                e0.key: <String>[
                  for (final dynamic i1 in (e0.value as List<dynamic>)) i1 as String,
                ],
            },
    );
  }

  /// Returns a string with the properties of [JsonOptions]
  @override
  String toString() {
    return '''JsonOptions(
  <keyNameConvention= $keyNameConvention>,
  <nameConventionGlobs= $nameConventionGlobs>,
)''';
  }
}

@DataClass()
class DataClassOptions {
  /// Shorthand constructor
  const DataClassOptions({
    this.optionsConfig = const <String, DataClassOptionConfig>{},
  });

  final Map<String, DataClassOptionConfig> optionsConfig;

  /// Creates an instance of [DataClassOptions] from [json]
  factory DataClassOptions.fromJson(Map<String, dynamic> json) {
    return DataClassOptions(
      optionsConfig: json['options_config'] == null
          ? const <String, DataClassOptionConfig>{}
          : <String, DataClassOptionConfig>{
              for (final MapEntry<String, dynamic> e0
                  in (json['options_config'] as Map<String, dynamic>).entries)
                e0.key: DataClassOptionConfig.fromJson(e0.value),
            },
    );
  }

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

  /// Returns a string with the properties of [DataClassOptions]
  @override
  String toString() {
    return '''DataClassOptions(
  <optionConfig= $optionsConfig>,
)''';
  }
}

@DataClass()
class DataClassOptionConfig {
  /// Shorthand constructor
  const DataClassOptionConfig({
    this.defaultValue,
    this.enabled = const <String>[],
    this.disabled = const <String>[],
  });

  @JsonKey(name: 'default')
  final bool? defaultValue;
  final List<String> enabled;
  final List<String> disabled;

  /// Creates an instance of [DataClassOptionConfig] from [json]
  factory DataClassOptionConfig.fromJson(Map<String, dynamic> json) {
    return DataClassOptionConfig(
      defaultValue: json['default'] == null ? null : json['default'] as bool,
      enabled: json['enabled'] == null
          ? const <String>[]
          : <String>[
              for (final dynamic i0 in (json['enabled'] as List<dynamic>)) i0 as String,
            ],
      disabled: json['disabled'] == null
          ? const <String>[]
          : <String>[
              for (final dynamic i0 in (json['disabled'] as List<dynamic>)) i0 as String,
            ],
    );
  }

  /// Returns a string with the properties of [DataClassOptionConfig]
  @override
  String toString() {
    return '''DataClassOptionConfig(
  <defaultValue= $defaultValue>,
  <enabled= $enabled>,
  <disabled= $disabled>,
)''';
  }
}
