import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:data_class_plugin/src/cli/commands/exceptions.dart';
import 'package:data_class_plugin/src/common/utils.dart';
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';
import 'package:path/path.dart' as path;

mixin FileGenerationCommandMixin on Command<dynamic> {
  Directory get directory;

  void ensureHasPubspec() {
    final bool hasPubspecYaml = directory
        .listSync() //
        .any((FileSystemEntity entity) =>
            entity is File && path.basename(entity.path) == 'pubspec.yaml');

    if (!hasPubspecYaml) {
      throw const NoPubspecFoundException();
    }
  }

  Future<void> ensureIsFileGenerationMode() async {
    final DataClassPluginOptions pluginOptions = await DataClassPluginOptions.fromFile(
      getDataClassPluginOptionsFile(directory.path),
    );
    if (pluginOptions.generationMode == CodeGenerationMode.inPlace) {
      throw const RequiresFileGenerationModeException();
    }
  }
}
