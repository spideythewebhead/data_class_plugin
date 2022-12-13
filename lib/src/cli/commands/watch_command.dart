import 'dart:async';
import 'dart:io';

import 'package:data_class_plugin/src/backend/code_generator.dart';
import 'package:data_class_plugin/src/cli/commands/base_command.dart';
import 'package:data_class_plugin/src/cli/commands/exceptions.dart';
import 'package:data_class_plugin/src/cli/commands/extensions.dart';

class WatchCommand extends BaseCommand with HasPubspecYamlMixin {
  WatchCommand({
    required super.logger,
    required this.directory,
  }) : _codeGenerator = CodeGenerator(directory: directory);

  final CodeGenerator _codeGenerator;

  @override
  final Directory directory;

  @override
  final String name = 'watch';

  @override
  final String description = 'Watches project for files changes and rebuilds when necessary';

  @override
  Future<void> execute() async {
    if (!hasPubspec()) {
      throw const NoPubspecFound();
    }

    ProcessSignal.sigterm.watch().listen((_) => _dispose());
    ProcessSignal.sigint.watch().listen((_) => _dispose());

    await _codeGenerator.watchProject(onReady: () => print('Listening'));
  }

  void _dispose() {
    logger.writeln('Stopping..');
    _codeGenerator.dispose();
    exit(0);
  }
}
