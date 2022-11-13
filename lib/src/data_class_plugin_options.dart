import 'dart:convert';
import 'dart:io' as io show File;

import 'package:data_class_plugin/src/annotations/json_key.dart';
import 'package:data_class_plugin/src/json_key_name_convention.dart';
import 'package:yaml/yaml.dart';

class DataClassPluginOptions {
  /// Shorthand constructor
  const DataClassPluginOptions({
    this.json = const JsonOptions(),
  });

  final JsonOptions json;

  static Future<DataClassPluginOptions> fromFile(String path) async {
    try {
      final YamlMap yaml =
          await io.File(path).readAsString().then((String value) => loadYaml(value));
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
    );
  }

  /// Returns a string with the properties of [DataClassPluginOptions]
  @override
  String toString() {
    return '''DataClassPluginOptions(
  <json= $json>,
)''';
  }
}

class JsonOptions {
  /// Shorthand constructor
  const JsonOptions({
    this.keyNameConvention,
    this.nameConventionGlobs = const <String, List<String>>{},
  });

  @JsonKey(nameConvention: JsonKeyNameConvention.snakeCase)
  final String? keyNameConvention;

  @JsonKey(
    name: 'key_name_conventions',
    nameConvention: JsonKeyNameConvention.snakeCase,
  )
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
  <globToNameConvention= $nameConventionGlobs>,
)''';
  }
}
