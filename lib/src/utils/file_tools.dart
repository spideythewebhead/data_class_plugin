import 'dart:io';
import 'package:data_class_plugin/src/utils/shell_command.dart';
import 'package:path/path.dart' as path;

class FileTools {
  static void createFile(
    final String path, {
    final bool recursive = false,
  }) {
    final File file = File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: recursive);
    }
  }

  // ----------------------------------------------------------------------------------------------------

  static void deleteFiles(
    final List<String> paths, {
    final bool recursive = false,
  }) {
    for (final String path in paths) {
      deleteFile(path, recursive: recursive);
    }
  }

  static void deleteFile(
    final String path, {
    final bool recursive = false,
  }) {
    final File file = File(path);
    if (!file.existsSync()) {
      file.deleteSync(recursive: recursive);
    }
  }

  // ----------------------------------------------------------------------------------------------------

  static String joinPath(final List<String> parts) {
    return path.joinAll(parts);
  }

  // ----------------------------------------------------------------------------------------------------

  static void createDirectory(
    final String path, {
    final bool recursive = false,
  }) {
    final Directory directory = Directory(path);
    if (!directory.existsSync()) {
      directory.createSync(recursive: recursive);
    }
  }

  static void deleteDirectory(
    final String path, {
    final bool recursive = false,
  }) {
    final Directory directory = Directory(path);
    if (directory.existsSync()) {
      directory.deleteSync(recursive: recursive);
    }
  }

  static Future<List<String>> findFile(
    final String file,
    final String path,
    final bool recursive,
  ) async {
    late final ShellCommand command;

    // TODO: Fix recursive

    if (Platform.isWindows) {
      command = ShellCommand(
        executable: 'dir ',
        arguments: <String>['/S', '/B', 'OG', file],
        workingDirectory: path,
      );
    } else if (Platform.isLinux || Platform.isMacOS) {
      command = ShellCommand(
        executable: 'find',
        arguments: <String>['..', '&&', 'find', '~+', '-type', 'f', '-name', file],
        workingDirectory: path,
      );
    } else {
      throw Exception('Not supported platform');
    }

    print('${command.executable} ${command.arguments.join(' ')}');

    final ProcessResult result = await command.run();
    final List<String> paths = result //
        .stdout
        .toString()
        .trim()
        .replaceAll('\r', '')
        .split('\n');

    if (paths.length == 1 && paths[0].isEmpty) {
      paths.clear();
    }

    return paths;
  }
}
