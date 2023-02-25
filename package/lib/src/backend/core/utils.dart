import 'package:data_class_plugin/src/common/utils.dart' as common_utils;
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';
import 'package:data_class_plugin/src/typedefs.dart';

JsonKeyNameConventionGetter getJsonKeyNameConvention({
  required final String targetFileRelativePath,
  required final DataClassPluginOptions pluginOptions,
}) {
  return (String? availableConvention) {
    return common_utils.getJsonKeyNameConvention(
      nameConvention: availableConvention,
      targetFileRelativePath: targetFileRelativePath,
      pluginOptions: pluginOptions,
    );
  };
}
