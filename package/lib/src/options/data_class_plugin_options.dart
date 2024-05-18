import 'dart:io' as io show File;

import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:data_class_plugin/src/options/options.dart';
import 'package:yaml/yaml.dart';

export 'options.dart';

part 'data_class_plugin_options.gen.dart';

@DataClass()
abstract class DataClassPluginOptions {
  const DataClassPluginOptions.ctor();

  /// Default constructor
  const factory DataClassPluginOptions({
    bool autoDeleteCodeFromAnnotation,
    JsonOptions json,
    DataClassOptions dataClass,
    EnumOptions $enum,
    UnionOptions union,
  }) = _$DataClassPluginOptionsImpl;

  /// Creates an instance of [DataClassPluginOptions] from [json]
  factory DataClassPluginOptions.fromJson(Map<dynamic, dynamic> json) =
      _$DataClassPluginOptionsImpl.fromJson;

  @DefaultValue(false)
  bool get autoDeleteCodeFromAnnotation;

  @DefaultValue(JsonOptions())
  JsonOptions get json;

  @DefaultValue(DataClassOptions())
  DataClassOptions get dataClass;

  @JsonKey(name: 'enum')
  @DefaultValue(EnumOptions())
  EnumOptions get $enum;

  @DefaultValue(UnionOptions())
  UnionOptions get union;

  static DataClassPluginOptions fromFile(io.File file) {
    return DataClassPluginOptions.fromJson(loadYaml(file.readAsStringSync()));
  }
}
