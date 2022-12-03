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
import 'package:data_class_plugin/src/logger.dart';

class DataClassPlugin extends ServerPlugin with AssistsMixin, DartAssistsMixin {
  DataClassPlugin(analyzer.ResourceProvider provider) : super(resourceProvider: provider);

  @override
  List<String> get fileGlobsToAnalyze => const <String>['*.dart'];

  @override
  String get contactInfo => 'https://github.com/spideythewebhead/dart_data_class_plugin/issues';

  @override
  String get name => 'data_class_plugin';

  String get displayName => '$name v$version';

  @override
  String get version => '1.0.0';

  final Logger _logger = Logger();
  late final PluginLinter _linter;

  @override
  void start(PluginCommunicationChannel channel) {
    super.start(channel);
    _logger.channel = channel;
    _linter = PluginLinter(_logger);

    _logger.notification('Starting $displayName');
  }

  @override
  Future<void> analyzeFile({
    required AnalysisContext analysisContext,
    required String path,
  }) async {
    // _logger.notification('Analyzing $path');

    final bool willAnalyze = analysisContext.contextRoot.isAnalyzed(path);
    // TODO: Fix file pattern matching
    if (!willAnalyze || !path.endsWith('.dart')) {
      return;
    }

    try {
      await _linter.check(path, analysisContext);
    } catch (e, st) {
      _logger.error(e, st);
    }
  }

  @override
  Future<void> analyzeFiles({
    required AnalysisContext analysisContext,
    required List<String> paths,
  }) async {
    // _logger.notification('Analyzing ${paths.length} paths');
    // for(final String path in paths){
    //
    // }

    await super.analyzeFiles(
      analysisContext: analysisContext,
      paths: paths,
    );
  }

  @override
  Future<PluginShutdownResult> handlePluginShutdown(PluginShutdownParams parameters) async {
    _logger.notification('Shutting down $displayName');
    return await super.handlePluginShutdown(parameters);
  }

  @override
  List<AssistContributor> getAssistContributors(String path) {
    try {
      return <AssistContributor>[
        // Class contributors
        ShorthandConstructorAssistContributor(path),
        DataClassAssistContributor(path),
        // FromJsonAssistContributor(path),
        // ToJsonAssistContributor(path),
        // CopyWithAssistContributor(path),
        // HashAndEqualsAssistContributor(path),

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
      _logger.error(e, st);
      return <AssistContributor>[];
    }
  }
}
