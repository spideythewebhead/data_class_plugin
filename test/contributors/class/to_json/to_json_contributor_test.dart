import 'dart:io' as io;

import 'package:data_class_plugin/src/contributors/class/class_contributors.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../../utils/utils.dart';

final String _contributorsPath = path.join(
  io.Directory.current.path,
  'test',
  'contributors',
  'class',
  'to_json',
);

void main() {
  final List<InOutFilesPair> testFiles = getTestFiles(_contributorsPath);

  group('toJson contributor', () {
    testFiles.runContributorTests(
      contributor: (String path) => ToJsonAssistContributor(path),
    );
  });
}