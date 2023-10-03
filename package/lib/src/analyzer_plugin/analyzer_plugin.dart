import 'package:analyzer/dart/analysis/analysis_context.dart' as analyzer;
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/file_system/file_system.dart' as analyzer;
import 'package:analyzer_plugin/plugin/assist_mixin.dart';
import 'package:analyzer_plugin/plugin/plugin.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';
// Workaround until DartAssistsMixin can be actually used as a mixin
// ignore: implementation_imports
import 'package:analyzer_plugin/src/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:data_class_plugin/src/contributors/class/class_contributors.dart';
import 'package:data_class_plugin/src/contributors/enum/enum_contributors.dart';

class DcpAnalyzerPlugin extends ServerPlugin with AssistsMixin, WorkaroundDartAssistsMixin {
  DcpAnalyzerPlugin(
    final analyzer.ResourceProvider resourceProvider,
  ) : super(resourceProvider: resourceProvider);

  @override
  List<String> get fileGlobsToAnalyze => const <String>['*.dart'];

  @override
  String get name => 'data_class_plugin';
  String get displayName => '$name v$version';

  @override
  String get contactInfo => 'https://github.com/spideythewebhead/dart_data_class_plugin/issues';

  @override
  String get version => '1.0.0';

  @override
  Future<void> analyzeFile({
    required analyzer.AnalysisContext analysisContext,
    required String path,
  }) async {}

  @override
  List<AssistContributor> getAssistContributors(String path) {
    return <AssistContributor>[
      // Class contributors
      ShorthandConstructorAssistContributor(path),
      DataClassAssistContributor(path),

      // Enum contributors
      EnumAnnotationAssistContributor(path),
      EnumConstructorAssistContributor(path),
      EnumFromJsonAssistContributor(path),
      EnumToJsonAssistContributor(path),
    ];
  }

  // @override
  // Future<PluginShutdownResult> handlePluginShutdown(PluginShutdownParams parameters) async {
  // _logger.notification('Shutting down $displayName');
  // await _logger.dispose();
  // return await super.handlePluginShutdown(parameters);
  // }

  // @override
  // void onError(Object exception, StackTrace stackTrace) {
  // _logger.exception(exception, stackTrace);
  // }
}

// TODO(): Remove once [DartAssistsMixin] can be used
abstract mixin class WorkaroundDartAssistsMixin implements AssistsMixin {
  @override
  Future<AssistRequest> getAssistRequest(EditGetAssistsParams parameters) async {
    final String path = parameters.file;
    final ResolvedUnitResult result = await getResolvedUnitResult(path);
    return DartAssistRequestImpl(resourceProvider, parameters.offset, parameters.length, result);
  }
}
