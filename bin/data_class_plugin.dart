import 'dart:io';

import 'package:data_class_plugin/src/cli.dart';

Future<void> main(List<String> args) async {
  try {
    await CliRunner().run(args);
    exitCode = 0;
  } on NoPubspecFoundException {
    stdout.writeln('No pubspec.yaml found.. Run this command on the root folder of your project');
    exitCode = 1;
  } on RequiresFileGenerationModeException {
    stdout.writeln('Code generation mode is set as "In-Place"');
    exitCode = 1;
  }
}
