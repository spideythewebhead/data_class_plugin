import 'dart:io' as io;

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:dart_style/dart_style.dart';
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
}
