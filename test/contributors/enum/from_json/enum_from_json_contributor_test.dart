import 'dart:io' as io;

import 'package:data_class_plugin/src/contributors/enum/enum_contributors.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../../utils/utils.dart';

final String _contributorsPath = path.join(
  io.Directory.current.path,
  'test',
  'contributors',
  'enum',
  'from_json',
);

void main() {
  final List<InOutFilesPair> testFiles = getTestFiles(_contributorsPath);

  group('enum fromJson contributor', () {
    testFiles.runContributorTests(
      contributor: (String path) => EnumFromJsonAssistContributor(path),
    );
  });
}
