import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:data_class_plugin/src/options/extensions.dart';
import 'package:data_class_plugin/src/options/options_config.dart';

@DataClass()
class UnionOptions {
  /// Shorthand constructor
  const UnionOptions({
    this.optionsConfig = const <String, OptionConfig>{},
  });

  final Map<String, OptionConfig> optionsConfig;

  bool effectiveDataClass(String filePath) =>
      optionsConfig.effectiveDataClass(filePath: filePath, defaultValue: true);

  bool effectiveFromJson(String filePath) =>
      optionsConfig.effectiveFromJson(filePath: filePath, defaultValue: false);

  bool effectiveToJson(String filePath) =>
      optionsConfig.effectiveToJson(filePath: filePath, defaultValue: false);

  /// Creates an instance of [UnionOptions] from [json]
  factory UnionOptions.fromJson(Map<dynamic, dynamic> json) {
    return UnionOptions(
      optionsConfig: json['options_config'] == null
          ? const <String, OptionConfig>{}
          : <String, OptionConfig>{
              for (final MapEntry<dynamic, dynamic> e0
                  in (json['options_config'] as Map<dynamic, dynamic>).entries)
                e0.key: OptionConfig.fromJson(e0.value),
            },
    );
  }
}
