library yamler;

import 'dart:io';

import 'package:data_class_plugin/src/core/exceptions.dart';
import 'package:data_class_plugin/src/extensions/yaml_extensions.dart';
import 'package:data_class_plugin/src/utils/yaml/json2yaml.dart';
import 'package:yaml/yaml.dart';

/// A library that provides tools to handle YAML files.
class Yamler {
  /// Returns a yaml converted from the given [path]
  static dynamic yamlFromFilePath(String path) {
    if (!checkFileExists(path)) {
      throw FileNotFoundException('Yaml file not found in $path');
    }

    return loadYaml(path);
  }

  /// Returns a yaml converted from the given [path]
  static YamlMap yamlFromFile(File file) {
    if (!file.existsSync()) {
      throw FileNotFoundException('Yaml file not found in ${file.path}');
    }

    return loadYaml(file.readAsStringSync());
  }

  /// Returns a [YamlMap] converted from the given [Map]
  static YamlMap yamlFromMap(Map<String, dynamic> map) {
    return YamlMap.wrap(map);
  }

  /// Returns a [Map] converted from the given [YamlMap]
  static Map<String, dynamic> mapFromYaml(YamlMap yaml) {
    return yaml.toMap();
  }

  /// Returns a [Map] converted from the given [file]
  static Map<String, dynamic> mapFromYamlFile(File file) {
    final YamlMap yaml = yamlFromFile(file);
    return mapFromYaml(yaml);
  }

  /// Returns a [Map] converted from the given file in [path]
  static Map<String, dynamic> mapFromYamlFilePath(String path) {
    if (!checkFileExists(path)) {
      throw FileNotFoundException('Yaml file not found in $path');
    }

    final YamlMap yaml = yamlFromFilePath(path);
    return mapFromYaml(yaml);
  }

  /// Returns a formatted yaml [String] converted
  /// from the given [Map]
  static String mapToYamlString(Map<String, dynamic> map) {
    return Json2YamlEncoder().convert(map);
  }

  static dynamic addValueToYamlList(dynamic list, String value) {
    if (list == null) {
      list = YamlList.wrap(<dynamic>[value]);
      return;
    }
    return (list as YamlList)..add(value);
  }

  /// Returns 'true' if the a [Directory] is found in the given [path]
  static bool checkDirectoryExists(String path) {
    final Directory directory = Directory(path);
    return directory.existsSync();
  }

  /// Returns 'true' if the a [File] is found in the given [path]
  static bool checkFileExists(String path) {
    final File file = File(path);
    return file.existsSync();
  }
}
