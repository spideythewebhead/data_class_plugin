import 'dart:io' as io;

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:data_class_plugin/src/contributors/common/to_string_assist_contributor.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../get_test_files_in_directory.dart';
import '../in_out_files_pair.dart';
import '../utils/utils.dart';

final String _contributorsPath = path.join(
  io.Directory.current.path,
  'test',
  'contributors',
  'to_string',
);

void main() {
  final List<InOutFilesPair> testFiles = getTestFiles(_contributorsPath);

  group('toString contributor', () {
    for (final InOutFilesPair pair in testFiles) {
      final String inPath = pair.input.path;
      final String outPath = pair.output.path;

      test('${path.basename(inPath)} -> ${path.basename(outPath)}', () async {
        final AnalysisContextCollection analysis = AnalysisContextCollection(
          includedPaths: <String>[inPath],
          resourceProvider: PhysicalResourceProvider.INSTANCE,
        );

        final ToStringAssistContributor contributor = ToStringAssistContributor(inPath);
        final AssistCollectorTest collector = AssistCollectorTest();

        await contributor.computeAssists(
          DartAssistRequestTest(
            offset: 0,
            length: 1,
            resourceProvider: PhysicalResourceProvider.INSTANCE,
            result: await analysis.contexts[0].currentSession
                .getResolvedUnit(inPath)
                .then((SomeResolvedUnitResult value) => value as ResolvedUnitResult),
          ),
          collector,
        );

        expect(collector.assists, hasLength(1));
        expect(
          io.File(outPath).readAsStringSync().removeTrailingWhitespace(),
          equals(collector.firstReplacement),
        );
      });
    }
  });
}
