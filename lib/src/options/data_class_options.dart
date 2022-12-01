import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:data_class_plugin/src/options/data_class_options_config.dart';
import 'package:data_class_plugin/src/options/extensions.dart';

@DataClass()
class DataClassOptions {
  /// Shorthand constructor
  const DataClassOptions({
    this.optionsConfig = const <String, OptionConfig>{},
  });

  final Map<String, OptionConfig> optionsConfig;

  bool effectiveCopyWith(String filePath) {
    return optionsConfig.hasGlobMatch('copy_with', filePath) ??
        optionsConfig['copy_with']?.defaultValue ??
        true;
  }

  bool effectiveHashAndEquals(String filePath) {
    return optionsConfig.hasGlobMatch('hash_and_equals', filePath) ??
        optionsConfig['hash_and_equals']?.defaultValue ??
        true;
  }

  bool effectiveToString(String filePath) {
    return optionsConfig.hasGlobMatch('to_string', filePath) ??
        optionsConfig['to_string']?.defaultValue ??
        true;
  }

  bool effectiveFromJson(String filePath) {
    return optionsConfig.hasGlobMatch('from_json', filePath) ??
        optionsConfig['from_json']?.defaultValue ??
        false;
  }

  bool effectiveToJson(String filePath) {
    return optionsConfig.hasGlobMatch('to_json', filePath) ??
        optionsConfig['to_json']?.defaultValue ??
        false;
  }

  /// Creates an instance of [DataClassOptions] from [json]
  factory DataClassOptions.fromJson(Map<dynamic, dynamic> json) {
    return DataClassOptions(
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
