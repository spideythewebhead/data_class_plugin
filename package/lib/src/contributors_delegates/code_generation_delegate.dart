import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';

abstract class CodeGenerationDelegate {
  const CodeGenerationDelegate({
    required this.relativeFilePath,
    required this.targetFilePath,
    required this.changeBuilder,
    required this.pluginOptions,
  });

  final String relativeFilePath;
  final String targetFilePath;
  final ChangeBuilder changeBuilder;
  final DataClassPluginOptions pluginOptions;

  Future<void> generate();
}
