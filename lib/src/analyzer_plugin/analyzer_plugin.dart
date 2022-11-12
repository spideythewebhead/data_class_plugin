import 'package:analyzer/dart/analysis/analysis_context.dart' as analyzer;
import 'package:analyzer/file_system/file_system.dart' as analyzer;
import 'package:analyzer_plugin/plugin/assist_mixin.dart';
import 'package:analyzer_plugin/plugin/plugin.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:data_class_plugin/src/contributors/class/class_contributors.dart';
import 'package:data_class_plugin/src/contributors/common/to_string_assist_contributor.dart';
import 'package:data_class_plugin/src/contributors/enum/enum_contributors.dart';

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
      // Class contributors
      ShorthandConstructorAssistContributor(path),
      DataClassAssistContributor(path),
      // FromJsonAssistContributor(path),
      // ToJsonAssistContributor(path),
      // CopyWithAssistContributor(path),
      // HashAndEqualsAssistContributor(path),

      // Enum contributors
      EnumConstructorAssistContributor(path),
      EnumFromJsonAssistContributor(path),
      EnumToJsonAssistContributor(path),

      // Common contributors
      ToStringAssistContributor(path),
      UnionAssistContributor(path),
    ];
  }
}
