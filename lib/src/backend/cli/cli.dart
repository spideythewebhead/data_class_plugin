import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:data_class_plugin/src/backend/cli/commands/build_command.dart';
import 'package:data_class_plugin/src/backend/cli/commands/watch_command.dart';

class Cli {
  Cli() {
    _runner =
        CommandRunner<void>('data_class_plugin', 'An alternative approach to generate dataclasses')
          ..addCommand(BuildCommand(Directory.current))
          ..addCommand(WatchCommand(Directory.current));
  }

  late final CommandRunner<void> _runner;

  FutureOr<void> execute(List<String> args) async {
    try {
      return await _runner.run(args);
    } catch (e) {
      print(e);
    }
  }
}
