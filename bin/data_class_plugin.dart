import 'dart:io';

import 'package:data_class_plugin/src/cli.dart';

Future<void> main(List<String> args) async {
  try {
    await CliRunner().run(args);
    exitCode = 0;
  } on NoPubspecFound {
    print('No pubspec.yaml found.. Run this command on the root folder of your project');
    exitCode = 1;
  }
}
