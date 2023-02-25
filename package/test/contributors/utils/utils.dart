import 'dart:io' as io;

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:data_class_plugin/src/analyzer_plugin/analyzer_plugin.dart';
import 'package:data_class_plugin/src/contributors/class/class_contributors.dart';
import 'package:data_class_plugin/src/contributors/common/to_string_assist_contributor.dart';
import 'package:data_class_plugin/src/contributors/enum/enum_contributors.dart';
import 'package:data_class_plugin/src/extensions/string_extensions.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

part 'extensions.dart';
part 'get_test_files_in_directory.dart';
part 'in_out_files_pair.dart';

class DartAssistRequestTest extends DartAssistRequest {
  /// Shorthand constructor
  DartAssistRequestTest({
    required this.length,
    required this.offset,
    required this.resourceProvider,
    required this.result,
  });

  @override
  final int length;

  @override
  final int offset;

  @override
  final ResourceProvider resourceProvider;

  @override
  final ResolvedUnitResult result;
}

class AssistCollectorTest extends AssistCollector {
  final List<PrioritizedSourceChange> assists = <PrioritizedSourceChange>[];

  @override
  void addAssist(PrioritizedSourceChange assist) => assists.add(assist);

  String get firstReplacement => assists[0].change.edits[0].edits[0].replacement;

  bool get hasMultipleReplacements => assists[0].change.edits[0].edits.length > 1;
}

const List<Type> availableContributors = <Type>[
  ShorthandConstructorAssistContributor,
  ToStringAssistContributor,
  DataClassAssistContributor,
  UnionAssistContributor,
  EnumAnnotationAssistContributor,
  EnumConstructorAssistContributor,
  EnumToJsonAssistContributor,
  EnumFromJsonAssistContributor,
];

Future<void> testContributorAssists({
  required final String assistGroupName,
  required final DataClassPlugin plugin,
  required final AnalysisContextCollection analysis,
  required final String filepath,
  required final List<Type> shouldHaveContributors,
  final OffsetProvider? offsetProvider,
}) async {
  group('$assistGroupName assist contributors', () {
    List<AssistContributor> contributors = <AssistContributor>[];
    ResolvedUnitResult? resolvedUnitResult;
    CompilationUnit? compilationUnit;

    setUp(() async {
      if (contributors.isEmpty) {
        contributors = plugin.getAssistContributors(filepath);
      }

      resolvedUnitResult ??= await analysis
          .contextFor(filepath)
          .currentSession
          .getResolvedUnit(filepath)
          .then((SomeResolvedUnitResult value) => value as ResolvedUnitResult);

      compilationUnit ??=
          (analysis.contextFor(filepath).currentSession.getParsedUnit(filepath) as ParsedUnitResult)
              .unit;
    });

    test('should have 8/${availableContributors.length} contributors', () {
      expect(contributors, isNotEmpty);
      expect(contributors.length, 8);
      expect(contributors.length == availableContributors.length, true);
    });

    // Verify that all required contributors return assists
    test('should have assists from ${shouldHaveContributors.length} contributors', () async {
      for (final Type contributor in shouldHaveContributors) {
        final AssistCollectorTest collector = AssistCollectorTest();
        final DartAssistRequestTest request = DartAssistRequestTest(
          offset: offsetProvider?.call(compilationUnit!) ?? compilationUnit!.beginToken.offset,
          length: resolvedUnitResult!.content.length,
          resourceProvider: PhysicalResourceProvider.INSTANCE,
          result: resolvedUnitResult!,
        );

        await contributors
            .where((AssistContributor c) => c.runtimeType == contributor)
            .first
            .computeAssists(request, collector);

        expect(collector.assists, hasLength(1));
      }
    });

    // Verify that none of the other available contributors return any assists
    test(
        'should not have assists from ${availableContributors.where((Type t) => !shouldHaveContributors.contains(t)).length} contributors',
        () async {
      final AssistCollectorTest collector = AssistCollectorTest();
      final DartAssistRequestTest request = DartAssistRequestTest(
        offset: offsetProvider?.call(compilationUnit!) ?? compilationUnit!.beginToken.offset,
        length: resolvedUnitResult!.content.length,
        resourceProvider: PhysicalResourceProvider.INSTANCE,
        result: resolvedUnitResult!,
      );

      await contributors
          .where((AssistContributor c) => !shouldHaveContributors.contains(c.runtimeType))
          .first
          .computeAssists(request, collector);

      expect(collector.assists, hasLength(0));
    });
  });
}
