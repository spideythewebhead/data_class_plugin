import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/annotations/data_class_internal.dart';
import 'package:data_class_plugin/src/common/code_writer.dart';
import 'package:data_class_plugin/src/contributors/class/class_contributors.dart';
import 'package:data_class_plugin/src/contributors/generators/generators.dart';
import 'package:data_class_plugin/src/contributors_delegates/class_generation_delegate.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';

class InPlaceDataClassDelegate extends ClassGenerationDelegate {
  InPlaceDataClassDelegate({
    required super.relativeFilePath,
    required super.targetFilePath,
    required super.changeBuilder,
    required super.pluginOptions,
    required super.classNodes,
  });

  @override
  Future<void> generate() async {
    await changeBuilder.addDartFileEdit(targetFilePath, (DartFileEditBuilder fileEditBuilder) {
      for (final ClassDeclaration classNode in classNodes) {
        final ClassElement classElement = classNode.declaredElement!;

        final DataClassInternal dataClassAnnotation = DataClassInternal.fromDartObject(
          classElement.metadata.dataClassAnnotation!.computeConstantValue(),
        );

        final SourceRange? constructorSourceRange = classNode.members.defaultConstructorSourceRange;
        final SourceRange? copyWithSourceRange = classNode.members.copyWithSourceRange;
        final SourceRange? equalsSourceRange = classNode.members.equalsSourceRange;
        final SourceRange? hashCodeSourceRange = classNode.members.hashSourceRange;
        final SourceRange? toStringSourceRange = classNode.members.toStringSourceRange;
        final SourceRange? fromJsonSourceRange = classNode.members.fromJsonSourceRange;
        final SourceRange? toJsonSourceRange = classNode.members.toJsonSourceRange;

        final List<VariableElement> fields = <VariableElement>[
          ...classElement.dataClassFinalFields,
          ...classElement.chainSuperClassDataClassFinalFields,
        ];

        void writerConstructor(DartEditBuilder builder) {
          ShorthandConstructorAssistContributor.writeConstructor(
            classElement: classElement,
            builder: builder,
            members: classNode.members,
          );
        }

        if (constructorSourceRange != null) {
          fileEditBuilder.addReplacement(
            constructorSourceRange,
            writerConstructor,
          );
        } else {
          fileEditBuilder.addInsertion(
            classNode.leftBracket.offset + 1,
            writerConstructor,
          );
        }

        if (dataClassAnnotation.$toString ??
            pluginOptions.dataClass.effectiveToString(relativeFilePath)) {
          void writerToString(DartEditBuilder builder) {
            ToStringGenerator(
              codeWriter: CodeWriter.dartEditBuilder(builder),
              className: classElement.thisType
                  .typeStringValue(enclosingImports: classElement.library.libraryImports)
                  .prefixGenericArgumentsWithDollarSign(),
              optimizedClassName: classElement.name,
              commentClassName: classElement.name,
              fields: fields,
            ).execute();
          }

          if (toStringSourceRange != null) {
            fileEditBuilder.addReplacement(
              toStringSourceRange,
              writerToString,
            );
          } else {
            fileEditBuilder.addInsertion(
              classNode.rightBracket.offset,
              writerToString,
            );
          }
        } else if (toStringSourceRange != null) {
          fileEditBuilder.addDeletion(toStringSourceRange);
        }

        if (dataClassAnnotation.hashAndEquals ??
            pluginOptions.dataClass.effectiveHashAndEquals(relativeFilePath)) {
          void writerHashCode(DartEditBuilder builder) {
            HashGenerator(
              codeWriter: CodeWriter.dartEditBuilder(builder),
              fields: fields,
            ).execute();
          }

          void writerEquals(DartEditBuilder builder) {
            EqualsGenerator(
              codeWriter: CodeWriter.dartEditBuilder(builder),
              className: classElement.thisType
                  .typeStringValue(enclosingImports: classElement.library.libraryImports),
              fields: fields,
            ).execute();
          }

          if (hashCodeSourceRange != null) {
            fileEditBuilder.addReplacement(hashCodeSourceRange, writerHashCode);
          } else {
            fileEditBuilder.addInsertion(
              classNode.rightBracket.offset,
              writerHashCode,
            );
          }

          if (equalsSourceRange != null) {
            fileEditBuilder.addReplacement(equalsSourceRange, writerEquals);
          } else {
            fileEditBuilder.addInsertion(
              classNode.rightBracket.offset,
              writerEquals,
            );
          }
        } else {
          if (hashCodeSourceRange != null) {
            fileEditBuilder.addDeletion(hashCodeSourceRange);
          }

          if (equalsSourceRange != null) {
            fileEditBuilder.addDeletion(equalsSourceRange);
          }
        }

        if (dataClassAnnotation.copyWith ??
            pluginOptions.dataClass.effectiveCopyWith(relativeFilePath)) {
          void writerCopyWith(DartEditBuilder builder) {
            CopyWithGenerator(
              codeWriter: CodeWriter.dartEditBuilder(builder),
              className: classElement.thisType
                  .typeStringValue(enclosingImports: classElement.library.libraryImports),
              commentClassName: classElement.name,
              classElement: classElement,
              fields: fields,
              annotateWithOverride: classElement.supertype?.classElement?.methods
                      .any((MethodElement method) => method.name == 'copyWith') ??
                  false,
            ).execute();
          }

          if (copyWithSourceRange != null) {
            fileEditBuilder.addReplacement(copyWithSourceRange, writerCopyWith);
          } else {
            fileEditBuilder.addInsertion(
              classNode.rightBracket.offset,
              writerCopyWith,
            );
          }
        } else if (copyWithSourceRange != null) {
          fileEditBuilder.addDeletion(copyWithSourceRange);
        }

        if (dataClassAnnotation.toJson ??
            pluginOptions.dataClass.effectiveToJson(relativeFilePath)) {
          void writerToJson(DartEditBuilder builder) {
            ToJsonGenerator(
              codeWriter: CodeWriter.dartEditBuilder(builder),
              className: classElement.name,
              fields: fields,
              annotateWithOverride: classElement.supertype?.classElement?.methods
                      .any((MethodElement method) => method.name == 'toJson') ??
                  false,
              libraryImports: classElement.library.libraryImports,
              targetFileRelativePath: relativeFilePath,
              pluginOptions: pluginOptions,
              checkIfShouldUseToJson: (DartType type) {
                return type.element == classElement;
              },
            ).execute();
          }

          if (toJsonSourceRange != null) {
            fileEditBuilder.addReplacement(toJsonSourceRange, writerToJson);
          } else {
            fileEditBuilder.addInsertion(
              classNode.rightBracket.offset,
              writerToJson,
            );
          }
        } else if (toJsonSourceRange != null) {
          fileEditBuilder.addDeletion(toJsonSourceRange);
        }

        if (dataClassAnnotation.fromJson ??
            pluginOptions.dataClass.effectiveFromJson(relativeFilePath)) {
          final ConstructorElement? defaultConstructor = classElement.defaultConstructor;

          void writerFromJson(DartEditBuilder builder) {
            FromJsonGenerator(
              codeWriter: CodeWriter.dartEditBuilder(builder),
              className: classElement.thisType
                  .typeStringValue(enclosingImports: classElement.library.libraryImports),
              fields: fields,
              factoryClassName: classElement.name,
              hasConstConstructor: defaultConstructor?.isConst ?? false,
              libraryImports: classElement.library.libraryImports,
              targetFileRelativePath: relativeFilePath,
              pluginOptions: pluginOptions,
              checkIfShouldUseFromJson: (DartType type) {
                return type.element == classElement;
              },
              getDefaultValueForField: (String fieldName) {
                return defaultConstructor?.parameters
                    .firstWhereOrNull((ParameterElement param) => param.name == fieldName)
                    ?.defaultValueCode;
              },
            ).execute();
          }

          if (fromJsonSourceRange != null) {
            fileEditBuilder.addReplacement(fromJsonSourceRange, writerFromJson);
          } else {
            fileEditBuilder.addInsertion(
              classNode.rightBracket.offset,
              writerFromJson,
            );
          }
        } else if (fromJsonSourceRange != null) {
          fileEditBuilder.addDeletion(fromJsonSourceRange);
        }

        fileEditBuilder.format(SourceRange(classNode.offset, classNode.length));
      }
    });
  }
}
