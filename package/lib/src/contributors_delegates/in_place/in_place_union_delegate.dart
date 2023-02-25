import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/annotations/constants.dart';
import 'package:data_class_plugin/src/annotations/union_internal.dart';
import 'package:data_class_plugin/src/common/code_writer.dart';
import 'package:data_class_plugin/src/contributors/generators/generators.dart';
import 'package:data_class_plugin/src/contributors_delegates/class_generation_delegate.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';
import 'package:data_class_plugin/src/visitors/class_visitor.dart';
import 'package:data_class_plugin/src/visitors/redirected_constructor_visitor.dart';

class InPlaceUnionDelegate extends ClassGenerationDelegate {
  InPlaceUnionDelegate({
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

        _generateWhenFunction(
          classElement: classElement,
          classNode: classNode,
          redirectedConstructors: redirectedConstructorsVisitor.result,
          fileEditBuilder: fileEditBuilder,
        );

        _generateMaybeWhenFunction(
          classElement: classElement,
          classNode: classNode,
          redirectedConstructors: redirectedConstructorsVisitor.result,
          fileEditBuilder: fileEditBuilder,
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

        _generateUnionImplementors(
          classElement: classElement,
          classNode: classNode,
          redirectedConstructors: redirectedConstructorsVisitor.result,
          fileEditBuilder: fileEditBuilder,
          unionInternalAnnotation: unionInternalAnnotation,
          pluginOptions: pluginOptions,
        );

        fileEditBuilder.format(SourceRange(classNode.offset, classNode.length));
      }
    });
  }

  void _generateMaybeWhenFunction({
    required final ClassElement classElement,
    required final Map<String, RedirectedConstructor> redirectedConstructors,
    required final ClassDeclaration classNode,
    required final DartFileEditBuilder fileEditBuilder,
  }) {
    final SourceRange? whenFunctionSourceRange =
        classNode.members.getSourceRangeForMethod('maybeWhen');

    void writerMaybeWhenFunction(DartEditBuilder builder) {
      _writeMaybeWhenFunction(
        classElement: classElement,
        builder: builder,
        redirectedConstructors: redirectedConstructors,
      );
    }

    if (whenFunctionSourceRange != null) {
      fileEditBuilder.addReplacement(
        whenFunctionSourceRange,
        writerMaybeWhenFunction,
      );
    } else {
      fileEditBuilder.addInsertion(
        classNode.rightBracket.offset,
        writerMaybeWhenFunction,
      );
    }
  }

  void _generateWhenFunction({
    required final ClassElement classElement,
    required final Map<String, RedirectedConstructor> redirectedConstructors,
    required final ClassDeclaration classNode,
    required final DartFileEditBuilder fileEditBuilder,
  }) {
    final SourceRange? mapFunctionSourceRange = classNode.members.getSourceRangeForMethod('when');

    void writerWhenFunction(DartEditBuilder builder) {
      _writeWhenFunction(
        classElement: classElement,
        builder: builder,
        redirectedConstructors: redirectedConstructors,
      );
    }

    if (mapFunctionSourceRange != null) {
      fileEditBuilder.addReplacement(
        mapFunctionSourceRange,
        writerWhenFunction,
      );
    } else {
      fileEditBuilder.addInsertion(
        classNode.rightBracket.offset,
        writerWhenFunction,
      );
    }
  }

  void _generateUnionImplementors({
    required final ClassElement classElement,
    required final ClassDeclaration classNode,
    required final Map<String, RedirectedConstructor> redirectedConstructors,
    required final DartFileEditBuilder fileEditBuilder,
    required final UnionInternal unionInternalAnnotation,
    required final DataClassPluginOptions pluginOptions,
  }) {
    for (final ConstructorElement ctor in classElement.constructors.reversed) {
      if (!ctor.isFactory || ctor.name.isEmpty || ctor.name == UnionAnnotationArg.fromJson.name) {
        continue;
      }

      final RedirectedConstructor redirectedCtor = redirectedConstructors[ctor.name]!;

      final ClassAstVisitor classVisitor = ClassAstVisitor(matcher: (ClassDeclaration node) {
        return redirectedCtor.name == node.name.lexeme;
      });
      compilationUnit.visitChildren(classVisitor);

      SourceRange? sourceRange;
      if (classVisitor.classNode != null) {
        sourceRange = SourceRange(
          classVisitor.classNode!.offset,
          classVisitor.classNode!.length,
        );
      }

      void writerUnionClass(DartEditBuilder builder) {
        _writeUnionClasses(
          classElement: classElement,
          builder: builder,
          constructorElement: ctor,
          redirectedCtor: redirectedCtor,
          unionInternalAnnotation: unionInternalAnnotation,
          pluginOptions: pluginOptions,
        );
      }

      if (sourceRange != null) {
        fileEditBuilder.addReplacement(
          sourceRange,
          writerUnionClass,
        );
      } else {
        fileEditBuilder.addInsertion(
          2 + classNode.rightBracket.offset,
          writerUnionClass,
        );
      }
    }
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

    if (sourceRange == null) {
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

  void _writeUnionClasses({
    required final ClassElement classElement,
    required final DartEditBuilder builder,
    required final ConstructorElement constructorElement,
    required final RedirectedConstructor redirectedCtor,
    required final UnionInternal unionInternalAnnotation,
    required final DataClassPluginOptions pluginOptions,
  }) {
    final CodeWriter codeWriter = CodeWriter.dartEditBuilder(builder);
    // Contains default values of constructor parameters
    final Map<String, String> defaultValues = <String, String>{};

    final List<VariableElement> sharedFields = classElement.fields.where((FieldElement field) {
      return field.getter != null && field.getter!.isGetter && field.getter!.isAbstract;
    }).toList(growable: false);

    codeWriter
      ..writeln('class $redirectedCtor extends ${classElement.thisType} {')
      ..writeln('const ${redirectedCtor.name}(');

    if (constructorElement.parameters.isNotEmpty) {
      codeWriter.write('{');

      for (final ParameterElement param in constructorElement.parameters) {
        final ElementAnnotation? defaultValueAnnotation = param.metadata.firstWhereOrNull(
            (ElementAnnotation annotation) => annotation.isDefaultValueAnnotation);

        if (!param.type.isNullable && defaultValueAnnotation == null) {
          codeWriter.write('required ');
        }

        codeWriter.write('this.${param.name}');

        if (defaultValueAnnotation != null) {
          // toSource will provide a value like "@DefaultValue<User>(User(username: 'test'))"
          // so we extract everything between the first pair of parenthesis
          final String? extractedValue =
              RegExp(r'\((.*)\)').firstMatch(defaultValueAnnotation.toSource())?.group(1)?.trim();

          if (extractedValue != null) {
            codeWriter.write(' = ');

            // if the extractedValue contains a pair of parenthesis we assume
            // that this is an instance declaration so we prefix with const
            bool isConst = false;
            if (extractedValue.contains(RegExp(r'\(.*\)'))) {
              codeWriter.write('const ');
              isConst = true;
            }
            codeWriter.write(extractedValue);

            defaultValues[param.name] = '${isConst ? 'const' : ''} $extractedValue';
          }
        }

        codeWriter.writeln(',');
      }

      codeWriter.write('}');
    }

    codeWriter
      ..writeln('): super._();')
      ..writeln();

    for (final ParameterElement param in constructorElement.parameters) {
      if (sharedFields.any((VariableElement field) => field.name == param.name)) {
        codeWriter.writeln('@override');
      }
      codeWriter.writeln(
          'final ${param.type.typeStringValue(enclosingImports: classElement.library.libraryImports)} ${param.name};');
    }

    if (unionInternalAnnotation.fromJson ??
        pluginOptions.union.effectiveFromJson(relativeFilePath)) {
      FromJsonGenerator(
        codeWriter: codeWriter,
        className: '$redirectedCtor',
        factoryClassName: redirectedCtor.name,
        fields: constructorElement.parameters,
        hasConstConstructor: constructorElement.isConst,
        libraryImports: classElement.library.libraryImports,
        targetFileRelativePath: relativeFilePath,
        pluginOptions: pluginOptions,
        checkIfShouldUseFromJson: (DartType type) {
          return type.element == classElement;
        },
        getDefaultValueForField: (String fieldName) => defaultValues[fieldName],
      ).execute();
    }

    if (unionInternalAnnotation.toJson ?? pluginOptions.union.effectiveToJson(relativeFilePath)) {
      ToJsonGenerator(
        codeWriter: codeWriter,
        className: redirectedCtor.name,
        fields: constructorElement.parameters,
        annotateWithOverride: true,
        libraryImports: classElement.library.libraryImports,
        targetFileRelativePath: relativeFilePath,
        pluginOptions: pluginOptions,
        checkIfShouldUseToJson: (DartType type) {
          return type.element == classElement;
        },
      ).execute();
    }

    if (unionInternalAnnotation.copyWith ??
        pluginOptions.union.effectiveCopyWith(relativeFilePath)) {
      CopyWithGenerator(
        codeWriter: CodeWriter.dartEditBuilder(builder),
        className: '$redirectedCtor',
        commentClassName: redirectedCtor.name,
        classElement: classElement,
        fields: constructorElement.parameters,
        annotateWithOverride: false,
      ).execute();
    }
    if (unionInternalAnnotation.hashAndEquals ??
        pluginOptions.union.effectiveHashAndEquals(relativeFilePath)) {
      HashGenerator(
        codeWriter: codeWriter,
        fields: constructorElement.parameters,
      ).execute();

      EqualsGenerator(
        codeWriter: codeWriter,
        className: '$redirectedCtor',
        fields: constructorElement.parameters,
      ).execute();
    }

    if (unionInternalAnnotation.$toString ??
        pluginOptions.union.effectiveToString(relativeFilePath)) {
      ToStringGenerator(
        codeWriter: CodeWriter.dartEditBuilder(builder),
        className: '$redirectedCtor'.prefixGenericArgumentsWithDollarSign(),
        optimizedClassName: redirectedCtor.name,
        commentClassName: redirectedCtor.name,
        fields: constructorElement.parameters,
      ).execute();
    }

    codeWriter.writeln('}');
  }

  void _writeWhenFunction({
    required final ClassElement classElement,
    required final DartEditBuilder builder,
    required final Map<String, RedirectedConstructor> redirectedConstructors,
  }) {
    final List<ConstructorElement> constructors = classElement.constructors
        .where((ConstructorElement ctor) => ctor.isFactory)
        .toList(growable: false);

    builder
      ..writeln()
      ..writeln('/// Executes one of the provided callbacks based on a type match')
      ..writeln('R when<R>({');

    for (final ConstructorElement ctor in constructors) {
      final RedirectedConstructor? redirectedCtor = redirectedConstructors[ctor.name];

      if (redirectedCtor == null) {
        continue;
      }

      if (ctor.parameters.isNotEmpty) {
        builder.writeln('required R Function($redirectedCtor value) ${ctor.name},');
      } else {
        builder.writeln('required R Function() ${ctor.name},');
      }
    }

    builder.writeln('}) {');

    for (final ConstructorElement ctor in constructors) {
      final RedirectedConstructor? redirectedCtor = redirectedConstructors[ctor.name];

      if (redirectedCtor == null) {
        continue;
      }

      builder.writeln('if (this is $redirectedCtor) {'
          'return ${ctor.name}('
          "${ctor.parameters.isNotEmpty ? 'this as $redirectedCtor' : ''}"
          ');}');
    }

    builder
      ..writeln("throw UnimplementedError('Unknown instance of \$this used in when(..)');")
      ..writeln('}');
  }

  void _writeMaybeWhenFunction({
    required final ClassElement classElement,
    required final DartEditBuilder builder,
    required final Map<String, RedirectedConstructor> redirectedConstructors,
  }) {
    final List<ConstructorElement> constructors = classElement.constructors
        .where((ConstructorElement ctor) => ctor.isFactory)
        .toList(growable: false);

    builder
      ..writeln()
      ..writeln('/// Executes one of the provided callbacks if a type is matched')
      ..writeln('///')
      ..writeln('/// If no match is found [orElse] is executed')
      ..writeln('R maybeWhen<R>({');

    for (final ConstructorElement ctor in constructors) {
      final RedirectedConstructor? redirectedCtor = redirectedConstructors[ctor.name];

      if (redirectedCtor == null) {
        continue;
      }

      if (ctor.parameters.isNotEmpty) {
        builder.writeln('R Function($redirectedCtor value)? ${ctor.name},');
      } else {
        builder.writeln('R Function()? ${ctor.name},');
      }
    }

    builder
      ..writeln('required R Function() orElse,')
      ..writeln('}) {');

    for (final ConstructorElement ctor in constructors) {
      final RedirectedConstructor? redirectedCtor = redirectedConstructors[ctor.name];

      if (redirectedCtor == null) {
        continue;
      }

      builder.writeln('if (this is $redirectedCtor) {'
          'return ${ctor.name}?.call('
          "${ctor.parameters.isNotEmpty ? 'this as $redirectedCtor' : ''}"
          ') ?? orElse();'
          '}');
    }

    builder
      ..writeln("throw UnimplementedError('Unknown instance of \$this used in maybeWhen(..)');")
      ..writeln('}');
  }

  void _writeGenerativeConstructor({
    required final ClassElement classElement,
    required final DartEditBuilder builder,
  }) {
    builder.writeln('const ${classElement.name}._();');
  }

  void _writeFromJsonFunction({
    required final ClassElement classElement,
    required final DartEditBuilder builder,
  }) {
    builder
      ..writeln('/// Creates an instance of [${classElement.name}] from [json]')
      ..writeln('factory ${classElement.name}.fromJson(Map<dynamic, dynamic> json) {')
      ..writeln('throw UnimplementedError();')
      ..writeln('}');
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
