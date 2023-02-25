import 'dart:io' as io;

import 'package:data_class_plugin/src/contributors/common/to_string_assist_contributor.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../../utils/utils.dart';

final String _contributorsPath = path.join(
  io.Directory.current.path,
  'test',
  'contributors',
  'enum',
  'to_string',
);

void main() {
  final List<InOutFilesPair> testFiles = getTestFiles(_contributorsPath);

  group('enum toString contributor', () {
    testFiles.runContributorTests(
      contributor: (String path) => ToStringAssistContributor(path),
    );
  });
}
