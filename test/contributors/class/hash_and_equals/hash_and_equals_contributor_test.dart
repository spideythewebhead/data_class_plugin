import 'dart:io' as io;

import 'package:data_class_plugin/src/contributors/class/hash_and_equals_assist_contributor.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../../utils/utils.dart';

final String _contributorsPath = path.join(
  io.Directory.current.path,
  'test',
  'contributors',
  'class',
  'hash_and_equals',
);

void main() {
  final List<InOutFilesPair> testFiles = getTestFiles(_contributorsPath);

  group('hashAndEquals contributor', () {
    testFiles.runContributorTests(
      contributorsPath: _contributorsPath,
      contributor: (String path) => HashAndEqualsAssistContributor(path),
    );
  });
}
