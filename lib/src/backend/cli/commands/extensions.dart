import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as path;

mixin HasPubspecYamlMixin on Command<dynamic> {
  Directory get directory;

  bool hasPubspec() {
    return directory
        .listSync() //
        .any((FileSystemEntity entity) =>
            entity is File && path.basename(entity.path) == 'pubspec.yaml');
  }
}
