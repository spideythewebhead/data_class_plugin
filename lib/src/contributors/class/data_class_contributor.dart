import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist_contributor_mixin.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:data_class_plugin/src/contributors/available_assists.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/generators/in-place/in_place_data_class_delegate.dart';
import 'package:data_class_plugin/src/mixins.dart';
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';

class DataClassAssistContributor extends Object
    with AssistContributorMixin, ClassAstVisitorMixin, RelativeFilePathMixin
    implements AssistContributor {
  DataClassAssistContributor(this.targetFilePath);

  @override
  final String targetFilePath;

  @override
  late final DartAssistRequest assistRequest;

  @override
  late final AssistCollector collector;

  @override
  AnalysisSession get session => assistRequest.result.session;

  @override
  Future<void> computeAssists(
    covariant DartAssistRequest request,
    AssistCollector collector,
  ) async {
    assistRequest = request;
    this.collector = collector;
    await _generateDataClass();
  }

  Future<void> _generateDataClass() async {
    final ClassDeclaration? classNode = findClassDeclaration();
    if (classNode == null || classNode.declaredElement == null) {
      return;
    }

    final ClassElement classElement = classNode.declaredElement!;
    if (classElement.hasUnionAnnotation || !classElement.hasDataClassAnnotation) {
      return;
    }

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    final DataClassPluginOptions pluginOptions =
        await session.analysisContext.contextRoot.root.getPluginOptions();

    final InPlaceDataClassDelegate delegate = InPlaceDataClassDelegate(
      relativeFilePath: relativeFilePath,
      targetFilePath: targetFilePath,
      classElement: classElement,
      classNode: classNode,
      pluginOptions: pluginOptions,
      changeBuilder: changeBuilder,
    );

    await delegate.generate();
    addAssist(AvailableAssists.dataClass, changeBuilder);
  }
}
