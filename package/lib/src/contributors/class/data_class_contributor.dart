import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist_contributor_mixin.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:data_class_plugin/src/contributors/available_assists.dart';
import 'package:data_class_plugin/src/contributors_delegates/code_generation_delegate.dart';
import 'package:data_class_plugin/src/contributors_delegates/file_generation/file_generation_data_class_delegate.dart';
import 'package:data_class_plugin/src/contributors_delegates/file_generation/file_generation_union_delegate.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/mixins.dart';
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';
import 'package:data_class_plugin/src/visitors/visitors.dart';

class DataClassAssistContributor extends AssistContributorMixin with RelativeFilePathMixin {
  DataClassAssistContributor(
    this.targetFilePath, {
    DataClassPluginOptions? pluginOptions,
  }) : _pluginOptions = pluginOptions;

  @override
  final String targetFilePath;

  late final DartAssistRequest assistRequest;

  @override
  late final AssistCollector collector;

  @override
  AnalysisSession get session => assistRequest.result.session;

  final DataClassPluginOptions? _pluginOptions;

  @override
  Future<void> computeAssists(
    covariant DartAssistRequest request,
    AssistCollector collector,
  ) async {
    assistRequest = request;
    this.collector = collector;
    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    await _generateDataClass(changeBuilder);
    await _generateUnion(changeBuilder);
    addAssist(AvailableAssists.dataAndUnionClasses, changeBuilder);
  }

  Future<void> _generateDataClass(final ChangeBuilder changeBuilder) async {
    final DataClassPluginOptions pluginOptions =
        _pluginOptions ?? await session.analysisContext.contextRoot.root.getPluginOptions();

    final ClassCollectorAstVisitor visitor =
        ClassCollectorAstVisitor(matcher: (ClassDeclaration node) => node.hasDataClassAnnotation);
    assistRequest.result.unit.visitChildren(visitor);

    if (visitor.matchedNodes.isEmpty) {
      return;
    }

    final CodeGenerationDelegate delegate = FileGenerationDataClassDelegate(
      relativeFilePath: relativeFilePath,
      targetFilePath: targetFilePath,
      changeBuilder: changeBuilder,
      pluginOptions: pluginOptions,
      classNodes: visitor.matchedNodes,
      compilationUnit: assistRequest.result.unit,
    );
    await delegate.generate();
  }

  Future<void> _generateUnion(final ChangeBuilder changeBuilder) async {
    final DataClassPluginOptions pluginOptions =
        _pluginOptions ?? await session.analysisContext.contextRoot.root.getPluginOptions();

    final ClassCollectorAstVisitor visitor =
        ClassCollectorAstVisitor(matcher: (ClassDeclaration node) => node.hasUnionAnnotation);
    assistRequest.result.unit.visitChildren(visitor);

    if (visitor.matchedNodes.isEmpty) {
      return;
    }

    final CodeGenerationDelegate delegate = FileGenerationUnionDelegate(
      relativeFilePath: relativeFilePath,
      targetFilePath: targetFilePath,
      changeBuilder: changeBuilder,
      pluginOptions: pluginOptions,
      classNodes: visitor.matchedNodes,
      compilationUnit: assistRequest.result.unit,
    );
    await delegate.generate();
  }
}
