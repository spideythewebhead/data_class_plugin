import 'dart:async';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/file_system/file_system.dart' as analyzer;
import 'package:analyzer_plugin/channel/channel.dart';
import 'package:analyzer_plugin/plugin/assist_mixin.dart';
import 'package:analyzer_plugin/plugin/plugin.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:data_class_plugin/src/contributors/class/class_contributors.dart';
import 'package:data_class_plugin/src/contributors/common/to_string_assist_contributor.dart';
import 'package:data_class_plugin/src/contributors/enum/enum_contributors.dart';
import 'package:data_class_plugin/src/linter/linter.dart';
import 'package:data_class_plugin/src/utils/logger/plugin_logger.dart';

class DataClassPlugin extends ServerPlugin with AssistsMixin, DartAssistsMixin {
  DataClassPlugin(analyzer.ResourceProvider provider, this._logger)
      : super(resourceProvider: provider);

  @override
  List<String> get fileGlobsToAnalyze => const <String>['*.dart'];

  @override
  String get contactInfo => 'https://github.com/spideythewebhead/dart_data_class_plugin/issues';

  @override
  String get name => 'data_class_plugin';

  String get displayName => '$name v$version';

  @override
  String get version => '1.0.0';

  final PluginLogger _logger;
  late final PluginLinter _linter;

  @override
  void start(PluginCommunicationChannel channel) {
    super.start(channel);
    _logger.channel = channel;
    _linter = PluginLinter(_logger);

    _logger.notification('Starting $displayName');
    _logger.writeln();
  }

  @override
  Future<void> analyzeFile({
    required AnalysisContext analysisContext,
    required String path,
  }) async {
    unawaited(checkLints(
      analysisContext: analysisContext,
      path: path,
    ));
  }

  @override
  Future<PluginShutdownResult> handlePluginShutdown(PluginShutdownParams parameters) async {
    _logger.notification('Shutting down $displayName');
    unawaited(_logger.dispose());
    return await super.handlePluginShutdown(parameters);
  }

  @override
  List<AssistContributor> getAssistContributors(String path) {
    try {
      return <AssistContributor>[
        // Class contributors
        ShorthandConstructorAssistContributor(path),
        DataClassAssistContributor(path),

        // Enum contributors
        EnumAnnotationAssistContributor(path),
        EnumConstructorAssistContributor(path),
        EnumFromJsonAssistContributor(path),
        EnumToJsonAssistContributor(path),

        // Common contributors
        ToStringAssistContributor(path),
        UnionAssistContributor(path),
      ];
    } catch (e, st) {
      _logger.exception(e, st);
      return <AssistContributor>[];
    }
  }

  Future<void> checkLints({
    required AnalysisContext analysisContext,
    required String path,
  }) async {
    // TODO: Fix file pattern matching
    if (!analysisContext.contextRoot.isAnalyzed(path) || !path.endsWith('.dart')) {
      return;
    }

    await _linter.check(path, analysisContext);
  }
}
