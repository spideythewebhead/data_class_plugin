import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:data_class_plugin/src/commands/analyze/analyze_command.dart';
import 'package:data_class_plugin/src/commands/base_command.dart';
import 'package:data_class_plugin/src/commands/install/install_command.dart';
import 'package:data_class_plugin/src/utils/logger/ansi.dart';

class CliRunner extends CommandRunner<void> {
  CliRunner([IOSink? sink])
      : super(
          'data_class_cli',
          'Data Class Plugin is a tool that allows you to '
                  'generate dart code on the fly.'
              .bold(),
        ) {
    // stdout.writeln(PluginLogger.pluginHeader());
    // stdout.writeln();

    <BaseCommand>[
      InstallCommand(sink),
      AnalyzeCommand(sink),
    ].forEach(addCommand);
  }
}
