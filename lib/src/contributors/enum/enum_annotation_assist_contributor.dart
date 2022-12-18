import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist_contributor_mixin.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/annotations/enum_internal.dart';
import 'package:data_class_plugin/src/common/code_writer.dart';
import 'package:data_class_plugin/src/contributors/available_assists.dart';
import 'package:data_class_plugin/src/contributors/enum/enum_contributors.dart';
import 'package:data_class_plugin/src/contributors/generators/generators.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/mixins.dart';
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';

class EnumAnnotationAssistContributor extends Object
    with AssistContributorMixin, EnumAstVisitorMixin, RelativeFilePathMixin
    implements AssistContributor {
  EnumAnnotationAssistContributor(this.targetFilePath);

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
    await _generateEnum();
  }

  Future<void> _generateEnum() async {
    final EnumDeclaration? enumNode = findEnumDeclaration();
    if (enumNode == null || enumNode.declaredElement == null || enumNode.semicolon == null) {
      return;
    }

    final EnumElement enumElement = enumNode.declaredElement!;

    if (enumElement.hasUnionAnnotation ||
        enumElement.hasDataClassAnnotation ||
        !enumElement.hasEnumAnnotation) {
      return;
    }

    final DataClassPluginOptions pluginOptions =
        await session.analysisContext.contextRoot.root.getPluginOptions();

    final EnumInternal enumAnnotation = EnumInternal.fromDartObject(
      enumElement.metadata.enumAnnotation!.computeConstantValue(),
    );

    final SourceRange? constructorSourceRange = enumNode.members.defaultConstructorSourceRange;
    final SourceRange? toStringSourceRange = enumNode.members.toStringSourceRange;
    final SourceRange? fromJsonSourceRange = enumNode.members.fromJsonSourceRange;
    final SourceRange? toJsonSourceRange = enumNode.members.toJsonSourceRange;

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    await changeBuilder.addDartFileEdit(targetFilePath, (DartFileEditBuilder fileEditBuilder) {
      void writerConstructor(DartEditBuilder builder) {
        EnumConstructorAssistContributor.writeConstructor(
          enumElement: enumElement,
          builder: builder,
          finalFieldsElements: enumElement.dataClassFinalFields,
        );
      }

      if (constructorSourceRange != null) {
        fileEditBuilder.addReplacement(
          constructorSourceRange,
          writerConstructor,
        );
      } else {
        fileEditBuilder.addInsertion(
          enumNode.semicolon!.charOffset + 1,
          writerConstructor,
        );
      }

      if (enumAnnotation.$toString ?? pluginOptions.$enum.effectiveToString(relativeFilePath)) {
        void writerToString(DartEditBuilder builder) {
          ToStringGenerator(
            codeWriter: CodeWriter.dartEditBuilder(builder),
            className: enumElement.thisType
                .typeStringValue(enclosingImports: enumElement.library.libraryImports)
                .prefixGenericArgumentsWithDollarSign(),
            optimizedClassName: enumElement.name,
            commentClassName: enumElement.name,
            fields: enumElement.dataClassFinalFields,
          ).execute();
        }

        if (toStringSourceRange != null) {
          fileEditBuilder.addReplacement(
            toStringSourceRange,
            writerToString,
          );
        } else {
          fileEditBuilder.addInsertion(
            enumNode.rightBracket.offset,
            writerToString,
          );
        }
      } else if (toStringSourceRange != null) {
        fileEditBuilder.addDeletion(toStringSourceRange);
      }

      if (enumAnnotation.toJson ?? pluginOptions.$enum.effectiveToJson(relativeFilePath)) {
        void writerToJson(DartEditBuilder builder) {
          EnumToJsonAssistContributor.writeToJson(
              enumElement: enumElement,
              builder: builder,
              fieldElement: enumElement.dataClassFinalFields.firstOrNull);
        }

        if (toJsonSourceRange != null) {
          fileEditBuilder.addReplacement(toJsonSourceRange, writerToJson);
        } else {
          fileEditBuilder.addInsertion(
            enumNode.rightBracket.offset,
            writerToJson,
          );
        }
      } else if (toJsonSourceRange != null) {
        fileEditBuilder.addDeletion(toJsonSourceRange);
      }

      if (enumAnnotation.fromJson ?? pluginOptions.$enum.effectiveFromJson(relativeFilePath)) {
        void writerFromJson(DartEditBuilder builder) {
          EnumFromJsonAssistContributor.writeFromJson(
              enumElement: enumElement,
              builder: builder,
              fieldElement: enumElement.dataClassFinalFields.firstOrNull);
        }

        if (fromJsonSourceRange != null) {
          fileEditBuilder.addReplacement(fromJsonSourceRange, writerFromJson);
        } else {
          fileEditBuilder.addInsertion(
            enumNode.rightBracket.offset,
            writerFromJson,
          );
        }
      } else if (fromJsonSourceRange != null) {
        fileEditBuilder.addDeletion(fromJsonSourceRange);
      }

      fileEditBuilder.format(SourceRange(enumNode.offset, enumNode.length));
    });

    addAssist(AvailableAssists.enumAnnotation, changeBuilder);
  }
}
