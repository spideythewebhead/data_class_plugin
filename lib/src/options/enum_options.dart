import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:data_class_plugin/src/options/extensions.dart';
import 'package:data_class_plugin/src/options/options_config.dart';

part 'enum_options.gen.dart';

@DataClass()
abstract class EnumOptions {
  const EnumOptions.ctor();

  /// Default constructor
  const factory EnumOptions({
    Map<String, OptionConfig> optionsConfig,
  }) = _$EnumOptionsImpl;

  /// Creates an instance of [EnumOptions] from [json]
  factory EnumOptions.fromJson(Map<dynamic, dynamic> json) = _$EnumOptionsImpl.fromJson;

  @DefaultValue(<String, OptionConfig>{})
  Map<String, OptionConfig> get optionsConfig;

  bool effectiveToString(String filePath) =>
      optionsConfig.effectiveToString(filePath: filePath, defaultValue: false);

  bool effectiveFromJson(String filePath) =>
      optionsConfig.effectiveFromJson(filePath: filePath, defaultValue: false);

  bool effectiveToJson(String filePath) =>
      optionsConfig.effectiveToJson(filePath: filePath, defaultValue: false);
}
