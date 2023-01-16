import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:data_class_plugin/src/options/extensions.dart';
import 'package:data_class_plugin/src/options/options_config.dart';

part 'data_class_options.gen.dart';

@DataClass()
abstract class DataClassOptions {
  const DataClassOptions.ctor();

  /// Default constructor
  const factory DataClassOptions({
    Map<String, OptionConfig> optionsConfig,
  }) = _$DataClassOptionsImpl;

  /// Creates an instance of [DataClassOptions] from [json]
  factory DataClassOptions.fromJson(Map<dynamic, dynamic> json) = _$DataClassOptionsImpl.fromJson;

  @DefaultValue(<String, OptionConfig>{})
  Map<String, OptionConfig> get optionsConfig;

  bool effectiveCopyWith(String filePath) =>
      optionsConfig.effectiveCopyWith(filePath: filePath, defaultValue: true);

  bool effectiveHashAndEquals(String filePath) =>
      optionsConfig.effectiveHashAndEquals(filePath: filePath, defaultValue: true);

  bool effectiveToString(String filePath) =>
      optionsConfig.effectiveToString(filePath: filePath, defaultValue: true);

  bool effectiveFromJson(String filePath) =>
      optionsConfig.effectiveFromJson(filePath: filePath, defaultValue: false);

  bool effectiveToJson(String filePath) =>
      optionsConfig.effectiveToJson(filePath: filePath, defaultValue: false);

  bool effectiveUnmodifiableCollections(String filePath) =>
      optionsConfig.effectiveUnmodifiableCollections(filePath: filePath, defaultValue: true);
}
