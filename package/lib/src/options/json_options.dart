import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';
import 'package:data_class_plugin/src/options/extensions.dart';
import 'package:data_class_plugin/src/options/options_config.dart';

part 'json_options.gen.dart';

@DataClass()
abstract class JsonOptions {
  const JsonOptions.ctor();

  /// Default constructor
  const factory JsonOptions({
    String? keyNameConvention,
    Map<String, List<String>> nameConventionGlobs,
    ToJsonOptions toJson,
  }) = _$JsonOptionsImpl;

  /// Creates an instance of [JsonOptions] from [json]
  factory JsonOptions.fromJson(Map<dynamic, dynamic> json) = _$JsonOptionsImpl.fromJson;

  String? get keyNameConvention;

  @JsonKey(name: 'key_name_conventions')
  @DefaultValue(<String, List<String>>{})
  Map<String, List<String>> get nameConventionGlobs;

  @DefaultValue(ToJsonOptions())
  ToJsonOptions get toJson;
}

@DataClass()
abstract class ToJsonOptions {
  const ToJsonOptions.ctor();

  /// Creates an instance of [ToJsonOptions] from [json]
  factory ToJsonOptions.fromJson(Map<dynamic, dynamic> json) = _$ToJsonOptionsImpl.fromJson;

  /// Default constructor
  const factory ToJsonOptions({
    Map<String, OptionConfig> optionsConfig,
  }) = _$ToJsonOptionsImpl;

  @DefaultValue(<String, OptionConfig>{})
  Map<String, OptionConfig> get optionsConfig;

  bool effectiveDropNullValues(String filePath) =>
      optionsConfig.effectiveToJsonDropNullValues(filePath: filePath, defaultValue: true);
}
