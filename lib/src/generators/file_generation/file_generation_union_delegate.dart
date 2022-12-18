import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/annotations/union_internal.dart';
import 'package:data_class_plugin/src/common/utils.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/generators/class_generation_delegate.dart';
import 'package:data_class_plugin/src/visitors/redirected_constructor_visitor.dart';

class FileGenerationUnionDelegate extends ClassGenerationDelegate {
  FileGenerationUnionDelegate({
    required super.relativeFilePath,
    required super.targetFilePath,
    required super.changeBuilder,
    required super.pluginOptions,
    required super.classNode,
    required super.classElement,
    required this.compilationUnit,
  });

  final CompilationUnit compilationUnit;

  @override
  Future<void> generate() async {
    await _generateConstructor();
  }

  Future<void> _generateConstructor() async {
    final UnionInternal unionInternalAnnotation = UnionInternal.fromDartObject(
      classElement.metadata.unionAnnotation!.computeConstantValue(),
    );

    final RedirectedConstructorsVisitor redirectedConstructorsVisitor =
        RedirectedConstructorsVisitor(result: <String, RedirectedConstructor>{});
    classNode.visitChildren(redirectedConstructorsVisitor);

    await changeBuilder.addDartFileEdit(
      targetFilePath,
      (DartFileEditBuilder fileEditBuilder) {
        if (!classElement.isAbstract) {
          fileEditBuilder.addInsertion(
            classNode.classKeyword.offset,
            (DartEditBuilder builder) {
              builder.write('abstract ');
            },
          );
        }

        addPartDirective(
          classElement: classElement,
          directives: compilationUnit.directives,
          fileEditBuilder: fileEditBuilder,
          targetFilePath: targetFilePath,
        );

        _generateGenerativeConstructor(
          classNode: classNode,
          classElement: classElement,
          fileEditBuilder: fileEditBuilder,
        );

        if (unionInternalAnnotation.fromJson ??
            pluginOptions.union.effectiveFromJson(relativeFilePath)) {
          _generateFromJsonFunction(
            classNode: classNode,
            classElement: classElement,
            fileEditBuilder: fileEditBuilder,
          );
        }

        if (unionInternalAnnotation.toJson ??
            pluginOptions.union.effectiveToJson(relativeFilePath)) {
          _generateToJsonFunction(
            classNode: classNode,
            classElement: classElement,
            fileEditBuilder: fileEditBuilder,
          );
        }

        fileEditBuilder.format(SourceRange(classNode.offset, classNode.length));
      },
    );
  }

  void _generateGenerativeConstructor({
    required final ClassElement classElement,
    required final ClassDeclaration classNode,
    required final DartFileEditBuilder fileEditBuilder,
  }) {
    final SourceRange? sourceRange = classNode.members.getSourceRangeForConstructor('_');

    void writerGenerativeConstructor(DartEditBuilder builder) {
      _writeGenerativeConstructor(
        classElement: classElement,
        builder: builder,
      );
    }

    if (sourceRange != null) {
      fileEditBuilder.addReplacement(
        sourceRange,
        writerGenerativeConstructor,
      );
    } else {
      fileEditBuilder.addInsertion(
        1 + classNode.leftBracket.offset,
        writerGenerativeConstructor,
      );
    }
  }

  void _generateFromJsonFunction({
    required final ClassDeclaration classNode,
    required final ClassElement classElement,
    required final DartFileEditBuilder fileEditBuilder,
  }) {
    final SourceRange? sourceRange = classNode.members.fromJsonSourceRange;

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
    required final DartFileEditBuilder fileEditBuilder,
  }) {
    final SourceRange? sourceRange = classNode.members.toJsonSourceRange;

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

  void _writeGenerativeConstructor({
    required final ClassElement classElement,
    required final DartEditBuilder builder,
  }) {
    builder
      ..writeln()
      ..writeln('const ${classElement.name}._();')
      ..writeln();
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