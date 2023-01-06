import 'dart:async';
import 'dart:io';

import 'package:data_class_plugin/src/backend/code_generator.dart';
import 'package:data_class_plugin/src/cli/commands/base_command.dart';
import 'package:data_class_plugin/src/cli/commands/extensions.dart';

class BuildCommand extends BaseCommand with FileGenerationCommandMixin {
  BuildCommand({
    required super.logger,
    required this.directory,
  }) : _codeGenerator = CodeGenerator(
          directory: directory,
          logger: logger,
        );

  final CodeGenerator _codeGenerator;

  @override
  final Directory directory;

  @override
  final String name = 'build';

  @override
  final String description = 'Builds project';

  @override
  Future<void> execute() async {
    ensureHasPubspec();
    await ensureIsFileGenerationMode();

    await _codeGenerator.indexProject();
    return await _codeGenerator.buildProject();
  }
}
