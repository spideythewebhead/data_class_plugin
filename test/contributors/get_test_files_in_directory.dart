import 'dart:io' as io show Directory, File;

import 'package:path/path.dart' as path;

import 'in_out_files_pair.dart';

List<InOutFilesPair> getTestFiles(String directoryPath) {
  final List<io.File> files = io.Directory(path.join(directoryPath, 'test_files'))
      .listSync()
      .whereType<io.File>()
      .toList(growable: false);

  final List<InOutFilesPair> pairs = <InOutFilesPair>[];

  for (final io.File inFile in files) {
    final String basename = path.basenameWithoutExtension(inFile.path);
    if (basename.startsWith('in_')) {
      final String suffix = basename.substring(3);
      final io.File outFile = files.firstWhere((io.File out) {
        final String outBasename = path.basenameWithoutExtension(out.path);
        return outBasename.startsWith('out_') && outBasename.substring(4) == suffix;
      });
      pairs.add(InOutFilesPair(input: inFile, output: outFile));
    }
  }

  return pairs;
}
