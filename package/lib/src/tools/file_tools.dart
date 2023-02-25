import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path/path.dart';

class FileTools {
  static final RegExp dartFileNameMatcher = RegExp(r'^[a-zA-Z0-9_]+.dart$');

  // ----------------------------------------------------------------------------------------------

  static void createFile(
    final String path, {
    final bool recursive = false,
  }) {
    final File file = File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: recursive);
    }
  }

  // ----------------------------------------------------------------------------------------------

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

  // ----------------------------------------------------------------------------------------------

  static String joinPath(final List<String> parts) {
    return path.joinAll(parts);
  }

  // ----------------------------------------------------------------------------------------------

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

  static List<String> findFiles({
    required final RegExp matchingPattern,
    required final String path,
    required final bool recursive,
  }) {
    return Directory(path)
        .listSync(recursive: recursive)
        .whereType<File>()
        .where((File file) => matchingPattern.hasMatch(basename(file.path)))
        .map((File file) => file.absolute.path)
        .toList(growable: false);
  }
}
