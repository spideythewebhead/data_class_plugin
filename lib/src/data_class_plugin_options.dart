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
    );
  }

  /// Returns a string with the properties of [DataClassPluginOptions]
  @override
  String toString() {
    String value = 'DataClassPluginOptions{<optimized out>}';
    assert(() {
      value = 'DataClassPluginOptions@<$hexIdentity>{json: $json, dataClass: $dataClass}';
      return true;
    }());
    return value;
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
  factory JsonOptions.fromJson(Map<dynamic, dynamic> json) {
    return JsonOptions(
      keyNameConvention:
          json['key_name_convention'] == null ? null : json['key_name_convention'] as String,
      nameConventionGlobs: json['key_name_conventions'] == null
          ? const <String, List<String>>{}
          : <String, List<String>>{
              for (final MapEntry<dynamic, dynamic> e0
                  in (json['key_name_conventions'] as Map<dynamic, dynamic>).entries)
                e0.key: <String>[
                  for (final dynamic i1 in (e0.value as List<dynamic>)) i1 as String,
                ],
            },
    );
  }

  /// Returns a string with the properties of [JsonOptions]
  @override
  String toString() {
    String value = 'JsonOptions{<optimized out>}';
    assert(() {
      value =
          'JsonOptions@<$hexIdentity>{keyNameConvention: $keyNameConvention, nameConventionGlobs: $nameConventionGlobs}';
      return true;
    }());
    return value;
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
  factory DataClassOptions.fromJson(Map<dynamic, dynamic> json) {
    return DataClassOptions(
      optionsConfig: json['options_config'] == null
          ? const <String, DataClassOptionConfig>{}
          : <String, DataClassOptionConfig>{
              for (final MapEntry<dynamic, dynamic> e0
                  in (json['options_config'] as Map<dynamic, dynamic>).entries)
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
    String value = 'DataClassOptions{<optimized out>}';
    assert(() {
      value = 'DataClassOptions@<$hexIdentity>{optionsConfig: $optionsConfig}';
      return true;
    }());
    return value;
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
  factory DataClassOptionConfig.fromJson(Map<dynamic, dynamic> json) {
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
    String value = 'DataClassOptionConfig{<optimized out>}';
    assert(() {
      value =
          'DataClassOptionConfig@<$hexIdentity>{defaultValue: $defaultValue, enabled: $enabled, disabled: $disabled}';
      return true;
    }());
    return value;
  }
}
