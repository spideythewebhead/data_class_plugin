import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:data_class_plugin/src/backend/cli/commands/exceptions.dart';
import 'package:data_class_plugin/src/backend/cli/commands/extensions.dart';
import 'package:data_class_plugin/src/backend/code_generator.dart';

class BuildCommand extends Command<void> with HasPubspecYamlMixin {
  BuildCommand(this.directory) : _codeGenerator = CodeGenerator(directory: directory);

  final CodeGenerator _codeGenerator;

  @override
  final Directory directory;

  @override
  final String name = 'build';

  @override
  final String description = 'Builds project';

  @override
  Future<void> run() async {
    if (!hasPubspec()) {
      throw const NoPubspecFound();
    }

    await _codeGenerator.indexProject();
    return await _codeGenerator.buildProject();
  }
}
