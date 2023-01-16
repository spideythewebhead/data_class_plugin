import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:data_class_plugin/src/options/extensions.dart';
import 'package:data_class_plugin/src/options/options_config.dart';

part 'union_options.gen.dart';

@DataClass()
abstract class UnionOptions {
  const UnionOptions.ctor();

  /// Default constructor
  const factory UnionOptions({
    Map<String, OptionConfig> optionsConfig,
  }) = _$UnionOptionsImpl;

  /// Creates an instance of [UnionOptions] from [json]
  factory UnionOptions.fromJson(Map<dynamic, dynamic> json) = _$UnionOptionsImpl.fromJson;

  @DefaultValue(<String, OptionConfig>{})
  Map<String, OptionConfig> get optionsConfig;

  bool effectiveCopyWith(String filePath) =>
      optionsConfig.effectiveCopyWith(filePath: filePath, defaultValue: false);

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
