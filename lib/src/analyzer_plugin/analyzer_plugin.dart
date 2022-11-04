import 'package:analyzer/dart/analysis/analysis_context.dart' as analyzer;
import 'package:analyzer/file_system/file_system.dart' as analyzer;
import 'package:analyzer_plugin/plugin/assist_mixin.dart';
import 'package:analyzer_plugin/plugin/plugin.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:data_class_plugin/src/contributors/copy_with_assist_contributor.dart';
import 'package:data_class_plugin/src/contributors/from_json_assist_contributor.dart';
import 'package:data_class_plugin/src/contributors/hash_and_equals_assist_contributor.dart';
import 'package:data_class_plugin/src/contributors/shorthand_constructor.dart';
import 'package:data_class_plugin/src/contributors/to_json_assist_contributor.dart';
import 'package:data_class_plugin/src/contributors/to_string_assist_contributor.dart';

class DataClassPlugin extends ServerPlugin with AssistsMixin, DartAssistsMixin {
  DataClassPlugin(analyzer.ResourceProvider provider) : super(resourceProvider: provider);

  @override
  List<String> get fileGlobsToAnalyze => const <String>['*.dart'];

  @override
  String get name => 'data_class_plugin';

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
      ShorthandConstructorAssistContributor(path),
      FromJsonAssistContributor(path),
      ToJsonAssistContributor(path),
      CopyWithAssistContributor(path),
      HashAndEqualsAssistContributor(path),
      ToStringAssistContributor(path),
    ];
  }
}
