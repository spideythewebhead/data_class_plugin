import 'package:data_class_plugin/src/extensions.dart';
import 'package:data_class_plugin/src/options/data_class_options_config.dart';
import 'package:glob/glob.dart';

extension OptionsGlobMatch on Map<String, OptionConfig> {
  bool? hasGlobMatch(String option, String filePath) {
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
}
