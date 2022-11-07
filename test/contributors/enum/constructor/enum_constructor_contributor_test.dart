import 'dart:io' as io;

import 'package:data_class_plugin/src/contributors/enum/enum_constructor_assist_contributor.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../../utils/utils.dart';

final String _contributorsPath = path.join(
  io.Directory.current.path,
  'test',
  'contributors',
  'enum',
  'constructor',
);

void main() {
  final List<InOutFilesPair> testFiles = getTestFiles(_contributorsPath);

  group('enum constructor contributor', () {
    testFiles.runContributorTests(
      contributorsPath: _contributorsPath,
      contributor: (String path) => EnumConstructorAssistContributor(path),
    );
  });
}
