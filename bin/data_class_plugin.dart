import 'dart:io';

import 'package:data_class_plugin/src/cli.dart';

void main(List<String> args) async {
  final Cli cli = Cli();

  try {
    await cli.execute(args);
  } on NoPubspecFound {
    print('No pubspec.yaml found.. Run this command on the root folder of your project');
    exit(1);
  }

  exit(0);
}
