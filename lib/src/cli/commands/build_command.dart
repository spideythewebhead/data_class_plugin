import 'dart:async';
import 'dart:io';

import 'package:data_class_plugin/src/backend/code_generator.dart';
import 'package:data_class_plugin/src/cli/commands/base_command.dart';
import 'package:data_class_plugin/src/cli/commands/exceptions.dart';
import 'package:data_class_plugin/src/cli/commands/extensions.dart';

class BuildCommand extends BaseCommand with HasPubspecYamlMixin {
  BuildCommand({
    required super.logger,
    required this.directory,
  }) : _codeGenerator = CodeGenerator(directory: directory);

  final CodeGenerator _codeGenerator;

  @override
  final Directory directory;

  @override
  final String name = 'build';

  @override
  final String description = 'Builds project';

  @override
  Future<void> execute() async {
    if (!hasPubspec()) {
      throw const NoPubspecFound();
    }

    await _codeGenerator.indexProject();
    return await _codeGenerator.buildProject();
  }
}
