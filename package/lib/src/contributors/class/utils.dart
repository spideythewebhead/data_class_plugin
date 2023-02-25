import 'package:data_class_plugin/src/annotations/json_key_internal.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/json_key_name_convention.dart';
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as path show join;

JsonKeyNameConvention getJsonKeyNameConvention({
  required final String targetFileRelativePath,
  required final JsonKeyInternal jsonKey,
  required final DataClassPluginOptions pluginOptions,
}) {
  String? nameConvention = jsonKey.nameConvention;

  nameConvention ??= pluginOptions.json.nameConventionGlobs.entries
      .firstWhereOrNull((MapEntry<String, List<String>> e) {
        return null !=
            e.value.firstWhereOrNull((String glob) => Glob(glob).matches(targetFileRelativePath));
      })
      ?.key
      .snakeCaseToCamelCase();

  nameConvention ??= pluginOptions.json.keyNameConvention?.snakeCaseToCamelCase() ??
      JsonKeyNameConvention.camelCase.name;

  return JsonKeyNameConvention.fromJson(nameConvention);
}

String getDataClassPluginOptionsPath(String root) {
  return path.join(root, 'data_class_plugin_options.yaml');
}
