import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:data_class_plugin/src/cli/commands/base_command.dart';
import 'package:data_class_plugin/src/cli/commands/generate/generate_command.dart';
import 'package:data_class_plugin/src/tools/logger/ansi.dart';
import 'package:data_class_plugin/src/tools/logger/plugin_logger.dart';

class CliRunner extends CommandRunner<void> {
  CliRunner([IOSink? sink])
      : logger = PluginLogger(ioSink: sink),
        super(
          'data_class_cli',
          'Data Class Plugin is a tool that allows you to '
                  'generate dart code on the fly.'
              .bold(),
        ) {
    logger.logHeader(PluginLogger.pluginHeader());
    logger.writeln('');

    <BaseCommand>[
      // InstallCommand(logger: logger),
      // AnalyzeCommand(logger: logger),
      GenerateCommand(logger: logger),
    ].forEach(addCommand);
  }

  final PluginLogger logger;
}
