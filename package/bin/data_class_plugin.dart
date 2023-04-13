import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:data_class_plugin/src/cli.dart';
import 'package:data_class_plugin/src/exceptions.dart';
import 'package:path/path.dart' as path;

Future<void> main(List<String> args) async {
  try {
    await CliRunner().run(args);
    exitCode = 0;
  } on DcpException catch (e) {
    e.when(
      pubspecYamlNotFound: () {
        stdout
            .writeln('No pubspec.yaml found.. Run this command on the root folder of your project');
      },
      dartToolFolderNotFound: () {
        stdout.writeln('Run "${Platform.executable} pub get" before running this tool');
      },
      requiresFileGenerationMode: () {
        stdout.writeln('Code generation mode is set as "in_place"');
      },
      packageNotFound: (DcpExceptionPackageNotFound exception) {
        final String executableBasename = path.basename(Platform.executable).toLowerCase();
        final bool isDartOrFlutterExecutable =
            executableBasename == 'dart' || executableBasename == 'flutter';
        stdout
          ..writeln()
          ..writeln('Package ${exception.packageName} is not installed.')
          ..writeln('To fix this either: ')
          ..writeln(
            '  1. Run "${isDartOrFlutterExecutable ? executableBasename : '<dart | flutter>'} pub get"',
          )
          ..writeln('  2. Remove any imports related to "${exception.packageName}"');
      },
    );

    exitCode = 1;
  } on UsageException catch (e) {
    stdout
      ..writeln(e.message)
      ..writeln()
      ..writeln(e.usage);

    exitCode = 1;
  }
}
