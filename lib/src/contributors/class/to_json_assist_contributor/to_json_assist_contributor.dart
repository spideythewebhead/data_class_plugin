import 'dart:io' as io show File;

import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist_contributor_mixin.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/annotations/json_key_internal.dart';
import 'package:data_class_plugin/src/contributors/available_assists.dart';
import 'package:data_class_plugin/src/contributors/class/to_json_assist_contributor/to_json_generator.dart';
import 'package:data_class_plugin/src/contributors/class/utils.dart' as utils;
import 'package:data_class_plugin/src/data_class_plugin_options.dart';
import 'package:data_class_plugin/src/extensions.dart';
import 'package:data_class_plugin/src/json_key_name_convention.dart';
import 'package:data_class_plugin/src/mixins.dart';

class ToJsonAssistContributor extends Object
    with AssistContributorMixin, ClassAstVisitorMixin, RelativeFilePathMixin
    implements AssistContributor {
  ToJsonAssistContributor(this.targetFilePath);

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
    await _generateToJson();
  }

  Future<void> _generateToJson() async {
    final ClassDeclaration? classNode = findClassDeclaration();
    if (classNode == null || classNode.members.isEmpty || classNode.declaredElement == null) {
      return;
    }

    final ClassElement classElement = classNode.declaredElement!;

    if (classElement.hasUnionAnnotation) {
      return;
    }

    final SourceRange? toJsonSourceRange = classNode.members.getSourceRangeForMethod('toJson');

    final DataClassPluginOptions pluginOptions = await DataClassPluginOptions.fromFile((io.File(
      utils.getDataClassPluginOptionsPath(session.analysisContext.contextRoot.root.path),
    )));

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    await changeBuilder.addDartFileEdit(
      targetFilePath,
      (DartFileEditBuilder fileEditBuilder) {
        void writerToJson(DartEditBuilder builder) {
          writeToJson(
            targetFileRelativePath: relativeFilePath,
            pluginOptions: pluginOptions,
            classElement: classElement,
            builder: builder,
          );
        }

        if (toJsonSourceRange != null) {
          fileEditBuilder.addReplacement(toJsonSourceRange, writerToJson);
        } else {
          fileEditBuilder.addInsertion(
            classNode.rightBracket.offset,
            writerToJson,
          );
        }

        fileEditBuilder.format(SourceRange(classNode.offset, classNode.length));
      },
    );

    addAssist(AvailableAssists.toJson, changeBuilder);
  }

  static void writeToJson({
    required final String targetFileRelativePath,
    required final DataClassPluginOptions pluginOptions,
    required final ClassElement classElement,
    required final DartEditBuilder builder,
  }) {
    builder
      ..writeln()
      ..writeln('/// Converts [${classElement.name}] to a [Map] json')
      ..writeln('Map<String, dynamic> toJson() {')
      ..writeln('return <String, dynamic>{');

    for (final VariableElement field in <VariableElement>[
      ...classElement.dataClassFinalFields,
      ...classElement.chainSuperClassDataClassFinalFields,
    ]) {
      final ElementAnnotation? jsonKeyAnnotation = field.metadata
          .firstWhereOrNull((ElementAnnotation annotation) => annotation.isJsonKeyAnnotation);
      final JsonKeyInternal jsonKey = JsonKeyInternal //
          .fromDartObject(jsonKeyAnnotation?.computeConstantValue());

      if (jsonKey.ignore) {
        continue;
      }

      final JsonKeyNameConvention jsonKeyNameConvention = utils.getJsonKeyNameConvention(
        targetFileRelativePath: targetFileRelativePath,
        jsonKey: jsonKey,
        pluginOptions: pluginOptions,
      );

      builder.write(
          "'${jsonKey.name ?? jsonKeyNameConvention.transform(field.name.escapeDollarSign())}': ");

      if (jsonKey.toJson != null) {
        builder
          ..write(jsonKey.toJson!
              .fullyQualifiedName(enclosingImports: classElement.library.libraryImports))
          ..write('(${field.name}),');
        continue;
      }

      ToJsonGenerator(
        checkIfShouldUseToJson: (DartType type) {
          return type.element == classElement;
        },
      ).run(
        nextType: field.type,
        builder: builder,
        parentVariableName: field.name,
        depthIndex: 0,
      );
    }

    builder
      ..writeln('};')
      ..writeln('}');
  }
}
