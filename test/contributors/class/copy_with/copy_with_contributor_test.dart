import 'dart:io' as io;

import 'package:data_class_plugin/src/contributors/class/copy_with_assist_contributor.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../../utils/utils.dart';

final String _contributorsPath = path.join(
  io.Directory.current.path,
  'test',
  'contributors',
  'class',
  'copy_with',
);

void main() {
  final List<InOutFilesPair> testFiles = getTestFiles(_contributorsPath);

  group('copyWith contributor', () {
    testFiles.runContributorTests(
      contributorsPath: _contributorsPath,
      contributor: (String path) => CopyWithAssistContributor(path),
    );
  });
}
