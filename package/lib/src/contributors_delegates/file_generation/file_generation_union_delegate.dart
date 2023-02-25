import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/annotations/union_internal.dart';
import 'package:data_class_plugin/src/common/utils.dart';
import 'package:data_class_plugin/src/contributors_delegates/class_generation_delegate.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/visitors/redirected_constructor_visitor.dart';

class FileGenerationUnionDelegate extends ClassGenerationDelegate {
  FileGenerationUnionDelegate({
    required super.relativeFilePath,
    required super.targetFilePath,
    required super.changeBuilder,
    required super.pluginOptions,
    required super.classNodes,
    required this.compilationUnit,
  });

  final CompilationUnit compilationUnit;

  @override
  Future<void> generate() async {
    await _generateConstructor();
  }

  Future<void> _generateConstructor() async {
    await changeBuilder.addDartFileEdit(targetFilePath, (DartFileEditBuilder fileEditBuilder) {
      for (final ClassDeclaration classNode in classNodes) {
        final ClassElement classElement = classNode.declaredElement!;

        final UnionInternal unionInternalAnnotation = UnionInternal.fromDartObject(
          classElement.metadata.unionAnnotation!.computeConstantValue(),
        );

        final SourceRange? privateConstructor = classNode.members.getSourceRangeForConstructor('_');
        final SourceRange? fromJsonSourceRange = classNode.members.fromJsonSourceRange;
        final SourceRange? toJsonSourceRange = classNode.members.toJsonSourceRange;

        final RedirectedConstructorsVisitor redirectedConstructorsVisitor =
            RedirectedConstructorsVisitor(result: <String, RedirectedConstructor>{});
        classNode.visitChildren(redirectedConstructorsVisitor);

        if (!classElement.isAbstract) {
          fileEditBuilder.addInsertion(
            classNode.classKeyword.offset,
            (DartEditBuilder builder) {
              builder.write('abstract ');
            },
          );
        }

        void createDefaultConstructor(DartEditBuilder builder) {
          _createDefaultConstructor(
            classElement: classElement,
            builder: builder,
            constructorName: '_',
          );
        }

        if (privateConstructor != null) {
          fileEditBuilder.addReplacement(
            privateConstructor,
            createDefaultConstructor,
          );
        } else {
          fileEditBuilder.addInsertion(
            classNode.leftBracket.offset + 1,
            createDefaultConstructor,
          );
        }

        addPartDirective(
          directives: compilationUnit.directives,
          fileEditBuilder: fileEditBuilder,
          targetFilePath: targetFilePath,
          partElements: classElement.library.parts,
        );

        if (unionInternalAnnotation.fromJson ??
            pluginOptions.union.effectiveFromJson(relativeFilePath)) {
          _generateFromJsonFunction(
            classNode: classNode,
            classElement: classElement,
            sourceRange: fromJsonSourceRange,
            fileEditBuilder: fileEditBuilder,
          );
        } else if (fromJsonSourceRange != null) {
          fileEditBuilder.addDeletion(fromJsonSourceRange);
        }

        if (unionInternalAnnotation.toJson ??
            pluginOptions.union.effectiveToJson(relativeFilePath)) {
          _generateToJsonFunction(
            classNode: classNode,
            classElement: classElement,
            fileEditBuilder: fileEditBuilder,
            sourceRange: toJsonSourceRange,
          );
        } else if (toJsonSourceRange != null) {
          fileEditBuilder.addDeletion(toJsonSourceRange);
        }

        fileEditBuilder.format(SourceRange(classNode.offset, classNode.length));
      }

      addPartDirective(
        partElements: classNodes[0].declaredElement!.library.parts,
        directives: compilationUnit.directives,
        fileEditBuilder: fileEditBuilder,
        targetFilePath: targetFilePath,
      );
    });
  }

  void _createDefaultConstructor({
    required final ClassElement classElement,
    required final DartEditBuilder builder,
    required final String constructorName,
  }) {
    final ConstructorElement? defaultConstructor = classElement.defaultConstructor;
    final bool isConst = defaultConstructor?.isConst ?? true;
    builder
      ..writeln()
      ..writeln('${isConst ? 'const' : ''} ${classElement.name}.$constructorName();')
      ..writeln();
  }

  void _generateFromJsonFunction({
    required final ClassDeclaration classNode,
    required final ClassElement classElement,
    required final SourceRange? sourceRange,
    required final DartFileEditBuilder fileEditBuilder,
  }) {
    if (sourceRange != null) {
      fileEditBuilder.addReplacement(
        sourceRange,
        (DartEditBuilder builder) =>
            _writeFromJsonFunction(classElement: classElement, builder: builder),
      );
    } else {
      fileEditBuilder.addInsertion(
        1 + classNode.leftBracket.offset,
        (DartEditBuilder builder) =>
            _writeFromJsonFunction(classElement: classElement, builder: builder),
      );
    }
  }

  void _generateToJsonFunction({
    required final ClassDeclaration classNode,
    required final ClassElement classElement,
    required final SourceRange? sourceRange,
    required final DartFileEditBuilder fileEditBuilder,
  }) {
    void writerToJsonFunction(DartEditBuilder builder) {
      _writeToJsonFunction(
        classElement: classElement,
        builder: builder,
      );
    }

    if (sourceRange != null) {
      fileEditBuilder.addReplacement(
        sourceRange,
        writerToJsonFunction,
      );
    } else {
      fileEditBuilder.addInsertion(
        classNode.rightBracket.offset,
        writerToJsonFunction,
      );
    }
  }

  void _writeFromJsonFunction({
    required final ClassElement classElement,
    required final DartEditBuilder builder,
  }) {
    final String className = classElement.name;
    final String optionalTypeParameters =
        classElement.typeParameters.join(', ').wrapWithAngleBracketsIfNotEmpty();
    builder
      ..writeln()
      ..writeln('/// Creates an instance of [$className] from [json]')
      ..writeln(
          'factory $className.fromJson(Map<dynamic, dynamic> json) => _\$${className}FromJson$optionalTypeParameters(json);');
  }

  void _writeToJsonFunction({
    required final ClassElement classElement,
    required final DartEditBuilder builder,
  }) {
    builder
      ..writeln('/// Converts [${classElement.name}] to [Map] json')
      ..writeln('Map<String, dynamic> toJson();');
  }
}
