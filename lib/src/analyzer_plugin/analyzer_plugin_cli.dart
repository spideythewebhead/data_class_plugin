import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:data_class_plugin/src/commands/analyze/analyze_command.dart';
import 'package:data_class_plugin/src/commands/base_command.dart';
import 'package:data_class_plugin/src/commands/generate/generate_command.dart';
import 'package:data_class_plugin/src/commands/install/install_command.dart';
import 'package:data_class_plugin/src/tools/logger/ansi.dart';
import 'package:data_class_plugin/src/tools/logger/plugin_logger.dart';

class CliRunner extends CommandRunner<void> {
  late final PluginLogger logger;
  CliRunner([IOSink? sink])
      : super(
          'data_class_cli',
          'Data Class Plugin is a tool that allows you to '
                  'generate dart code on the fly.'
              .bold(),
        ) {
    logger = PluginLogger(ioSink: sink);
    logger.logHeader(PluginLogger.pluginHeader());
    logger.writeln();

    <BaseCommand>[
      InstallCommand(logger),
      AnalyzeCommand(logger),
      GenerateCommand(logger),
    ].forEach(addCommand);
  }
}
