import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/annotations/data_class_internal.dart';
import 'package:data_class_plugin/src/contributors/class/class_contributors.dart';
import 'package:data_class_plugin/src/contributors/common/to_string_assist_contributor.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/generators/class_generation_delegate.dart';

class InPlaceDataClassDelegate extends ClassGenerationDelegate {
  InPlaceDataClassDelegate({
    required super.relativeFilePath,
    required super.targetFilePath,
    required super.changeBuilder,
    required super.pluginOptions,
    required super.classNode,
    required super.classElement,
  });

  @override
  Future<void> generate() async {
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

    await changeBuilder.addDartFileEdit(targetFilePath, (DartFileEditBuilder fileEditBuilder) {
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
          ToStringAssistContributor.writeToString(
            className: classElement.thisType
                .typeStringValue(enclosingImports: classElement.library.libraryImports)
                .prefixGenericArgumentsWithDollarSign(),
            optimizedName: classElement.name,
            commentElementName: classElement.name,
            fields: fields,
            builder: builder,
          );
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
          HashAndEqualsAssistContributor.writeHashCode(
            fields: fields,
            builder: builder,
          );
        }

        void writerEquals(DartEditBuilder builder) {
          HashAndEqualsAssistContributor.writeEquals(
            className: classElement.thisType.toString(),
            fields: fields,
            builder: builder,
          );
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
          CopyWithAssistContributor.writeCopyWith(
            className: classElement.thisType.toString(),
            classElement: classElement,
            commentClassName: classElement.name,
            fields: fields,
            builder: builder,
          );
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

      if (dataClassAnnotation.toJson ?? pluginOptions.dataClass.effectiveToJson(relativeFilePath)) {
        void writerToJson(DartEditBuilder builder) {
          ToJsonAssistContributor.writeToJson(
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
      } else if (toJsonSourceRange != null) {
        fileEditBuilder.addDeletion(toJsonSourceRange);
      }

      if (dataClassAnnotation.fromJson ??
          pluginOptions.dataClass.effectiveFromJson(relativeFilePath)) {
        void writerFromJson(DartEditBuilder builder) {
          FromJsonAssistContributor.writeFromJson(
            targetFileRelativePath: relativeFilePath,
            pluginOptions: pluginOptions,
            classElement: classElement,
            builder: builder,
          );
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
    });
  }
}
