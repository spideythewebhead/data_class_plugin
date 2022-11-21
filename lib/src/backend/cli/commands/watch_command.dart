import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:data_class_plugin/src/backend/cli/commands/exceptions.dart';
import 'package:data_class_plugin/src/backend/cli/commands/extensions.dart';
import 'package:data_class_plugin/src/backend/code_generator.dart';

class WatchCommand extends Command<void> with HasPubspecYamlMixin {
  WatchCommand(this.directory) : _codeGenerator = CodeGenerator(directory: directory) {
    ProcessSignal.sigterm.watch().listen((_) => _dispose());
    ProcessSignal.sigint.watch().listen((_) => _dispose());
  }

  final CodeGenerator _codeGenerator;

  @override
  final Directory directory;

  @override
  final String name = 'watch';

  @override
  final String description = 'Watches project for files changes and rebuilds when necessary';

  @override
  Future<void> run() async {
    if (!hasPubspec()) {
      throw const NoPubspecFound();
    }

    await _codeGenerator.watchProject(onReady: () => print('Listening'));
  }

  void _dispose() {
    print('Stopping..');
    _codeGenerator.dispose();
    exit(0);
  }
}
