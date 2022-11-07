import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';

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

extension StringX on String {
  String removeTrailingWhitespace() {
    return replaceFirst(RegExp(r'\s$'), '');
  }
}
