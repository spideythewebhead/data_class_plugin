import 'package:data_class_plugin/src/extensions/core_extensions.dart';
import 'package:data_class_plugin/src/options/options_config.dart';
import 'package:glob/glob.dart';

extension OptionsGlobMatch on Map<String, OptionConfig> {
  bool? _hasGlobMatch(String option, String filePath) {
    final String? isEnabled =
        this[option]?.enabled.firstWhereOrNull((String glob) => Glob(glob).matches(filePath));

    if (isEnabled != null) {
      return true;
    }

    final String? isDisabled =
        this[option]?.disabled.firstWhereOrNull((String glob) => Glob(glob).matches(filePath));

    if (isDisabled != null) {
      return false;
    }

    return null;
  }

  bool effectiveToString({required String filePath, required bool defaultValue}) {
    return _effectiveValue('to_string', filePath, defaultValue);
  }

  bool effectiveFromJson({required String filePath, required bool defaultValue}) {
    return _effectiveValue('from_json', filePath, defaultValue);
  }

  bool effectiveToJson({required String filePath, required bool defaultValue}) {
    return _effectiveValue('to_json', filePath, defaultValue);
  }

  bool effectiveCopyWith({required String filePath, required bool defaultValue}) {
    return _effectiveValue('copy_with', filePath, defaultValue);
  }

  bool effectiveHashAndEquals({required String filePath, required bool defaultValue}) {
    return _effectiveValue('hash_and_equals', filePath, defaultValue);
  }

  bool effectiveUnmodifiableCollections({required String filePath, required bool defaultValue}) {
    return _effectiveValue('unmodifiable_collections', filePath, defaultValue);
  }

  bool _effectiveValue(
    String method,
    String filePath,
    bool defaultValue,
  ) {
    return _hasGlobMatch(method, filePath) ?? this[method]?.defaultValue ?? defaultValue;
  }
}
