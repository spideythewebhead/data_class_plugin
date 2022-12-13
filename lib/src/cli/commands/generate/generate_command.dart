import 'dart:io';

import 'package:data_class_plugin/src/cli/commands/arguments.dart';
import 'package:data_class_plugin/src/cli/commands/base_command.dart';
import 'package:data_class_plugin/src/cli/commands/build_command.dart';
import 'package:data_class_plugin/src/cli/commands/generate/generate_argument.dart';
import 'package:data_class_plugin/src/cli/commands/watch_command.dart';
import 'package:data_class_plugin/src/tools/logger/ansi.dart';

class GenerateCommand extends BaseCommand {
  @override
  String get name => 'generate';

  @override
  String get description => 'Generate code as specified by annotations'.bold();

  GenerateCommand({
    required super.logger,
  }) {
    argParser.addArgumentOptions(GenerateArgument.values);

    addSubcommand(BuildCommand(logger: logger, directory: Directory.current));
    addSubcommand(WatchCommand(logger: logger, directory: Directory.current));
  }

  @override
  Future<void> init() async {
    await super.init();
  }

  @override
  Future<void> execute() async {
    // noop
  }
}
