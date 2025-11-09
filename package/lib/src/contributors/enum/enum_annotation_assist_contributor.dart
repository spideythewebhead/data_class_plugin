import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist_contributor_mixin.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/annotations/enum_internal.dart';
import 'package:data_class_plugin/src/contributors/available_assists.dart';
import 'package:data_class_plugin/src/contributors/enum/enum_constructor_assist_contributor.dart';
import 'package:data_class_plugin/src/contributors/enum/enum_from_json_assist_contributor.dart';
import 'package:data_class_plugin/src/contributors/enum/enum_to_json_assist_contributor.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/mixins.dart';
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';
import 'package:data_class_plugin/src/visitors/enum_visitor.dart';
import 'package:tachyon/tachyon.dart';

class EnumAnnotationAssistContributor extends AssistContributorMixin
    with EnumAstVisitorMixin, RelativeFilePathMixin {
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
    await _generateEnums();
  }

  Future<void> _generateEnums() async {
    final EnumsCollectorAstVisitor visitor = EnumsCollectorAstVisitor(
      matcher: (EnumDeclaration node) => node.hasEnumAnnotation,
    );
    assistRequest.result.unit.visitChildren(visitor);

    final List<EnumDeclaration> enumDeclarations = visitor.matchedNodes;

    if (enumDeclarations.isEmpty) {
      return;
    }

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    final DataClassPluginOptions pluginOptions = await session.analysisContext.contextRoot.root
        .getPluginOptions();

    for (final EnumDeclaration enumDeclaration in enumDeclarations) {
      final EnumElement2? enumElement = enumDeclaration.declaredFragment?.element;

      if (enumElement == null ||
          enumElement.metadata2.hasUnionAnnotation ||
          enumElement.metadata2.hasDataClassAnnotation ||
          !enumElement.metadata2.hasEnumAnnotation) {
        return;
      }

      final EnumInternal enumAnnotation = EnumInternal.fromDartObject(
        enumElement.metadata2.enumAnnotation!.computeConstantValue(),
      );

      final SourceRange? constructorSourceRange =
          enumDeclaration.members.defaultConstructorSourceRange;
      final SourceRange? fromJsonSourceRange = enumDeclaration.members.fromJsonSourceRange;
      final SourceRange? toJsonSourceRange = enumDeclaration.members.toJsonSourceRange;
      // final SourceRange? toStringSourceRange = enumDeclaration.members.getSourceRangeForMethod(
      //   'toString',
      // );

      await changeBuilder.addDartFileEdit(targetFilePath, (
        DartFileEditBuilder fileEditBuilder,
      ) {
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
          if (enumDeclaration.semicolon == null) {
            fileEditBuilder.addInsertion(
              enumDeclaration.rightBracket.charOffset - 1,
              (DartEditBuilder builder) {
                builder.write(';');
                writerConstructor(builder);
              },
            );
          } else {
            fileEditBuilder.addInsertion(
              enumDeclaration.semicolon!.charOffset + 1,
              writerConstructor,
            );
          }
        }

        if (enumAnnotation.fromJson ?? pluginOptions.$enum.effectiveFromJson(relativeFilePath)) {
          void writerFromJson(DartEditBuilder builder) {
            EnumFromJsonAssistContributor.writeFromJson(
              enumElement: enumElement,
              builder: builder,
              fieldElement: enumElement.dataClassFinalFields.firstOrNull,
              libraryImports: enumDeclaration.declaredFragment!.libraryFragment.libraryImports2,
            );
          }

          if (fromJsonSourceRange != null) {
            fileEditBuilder.addReplacement(fromJsonSourceRange, writerFromJson);
          } else {
            fileEditBuilder.addInsertion(
              enumDeclaration.rightBracket.offset,
              writerFromJson,
            );
          }
        } else if (fromJsonSourceRange != null) {
          fileEditBuilder.addDeletion(fromJsonSourceRange);
        }

        if (enumAnnotation.toJson ?? pluginOptions.$enum.effectiveToJson(relativeFilePath)) {
          void writerToJson(DartEditBuilder builder) {
            EnumToJsonAssistContributor.writeToJson(
              enumElement: enumElement,
              fieldElement: enumElement.dataClassFinalFields.firstOrNull,
              libraryImports: enumDeclaration.declaredFragment!.libraryFragment.libraryImports2,
              builder: builder,
            );
          }

          if (toJsonSourceRange != null) {
            fileEditBuilder.addReplacement(toJsonSourceRange, writerToJson);
          } else {
            fileEditBuilder.addInsertion(
              enumDeclaration.rightBracket.offset,
              writerToJson,
            );
          }
        } else if (toJsonSourceRange != null) {
          fileEditBuilder.addDeletion(toJsonSourceRange);
        }

        // if (enumAnnotation.$toString == true) {
        //   void writerToString(DartEditBuilder builder) {
        //     final List<DeclarationInfo> fields = <DeclarationInfo>[
        //       for (final FieldDeclaration parameter in fields)
        //         if (parameter is SimpleFormalParameter)
        //           DeclarationInfo(
        //             name: parameter.name!.lexeme,
        //             type: parameter.type,
        //             metadata: parameter.metadata,
        //             isNamed: parameter.isNamed,
        //             isRequired: parameter.isRequired,
        //             isPositional: parameter.isPositional,
        //           )
        //         else if (parameter is DefaultFormalParameter &&
        //             parameter.parameter is SimpleFormalParameter)
        //           DeclarationInfo(
        //             name: parameter.name!.lexeme,
        //             type: (parameter.parameter as SimpleFormalParameter).type,
        //             metadata: parameter.metadata,
        //             isNamed: parameter.isNamed,
        //             isRequired: parameter.isRequired,
        //             isPositional: parameter.isPositional,
        //           )
        //         else if (parameter is FieldFormalParameter)
        //           DeclarationInfo(
        //             name: parameter.name.lexeme,
        //             type: parameter.type,
        //             metadata: parameter.metadata,
        //             isNamed: parameter.isNamed,
        //             isRequired: parameter.isRequired,
        //             isPositional: parameter.isPositional,
        //           ),
        //     ];

        //     ToStringGenerator(
        //       codeWriter: CodeWriter.dartEditBuilder(builder),
        //       fields: fields,
        //       className: enumDeclaration.name.lexeme,
        //     ).execute();
        //   }

        //   if (toStringSourceRange != null) {
        //     fileEditBuilder.addReplacement(toStringSourceRange, writerToString);
        //   } else {
        //     fileEditBuilder.addInsertion(enumDeclaration.rightBracket.offset, writerToString);
        //   }
        // }

        fileEditBuilder.format(SourceRange(enumDeclaration.offset, enumDeclaration.length));
      });
    }

    addAssist(AvailableAssists.enumAnnotation, changeBuilder);
  }
}
