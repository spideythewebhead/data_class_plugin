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
import 'package:data_class_plugin/src/annotations/union_internal.dart';
import 'package:data_class_plugin/src/contributors/available_assists.dart';
import 'package:data_class_plugin/src/contributors/class/class_contributors.dart';
import 'package:data_class_plugin/src/contributors/class/from_json_assist_contributor/from_json_generator.dart';
import 'package:data_class_plugin/src/contributors/class/to_json_assist_contributor/to_json_generator.dart';
import 'package:data_class_plugin/src/contributors/common/to_string_assist_contributor.dart';
import 'package:data_class_plugin/src/extensions.dart';
import 'package:data_class_plugin/src/mixins.dart';
import 'package:data_class_plugin/src/visitors/class_visitor.dart';
import 'package:data_class_plugin/src/visitors/redirected_constructor_visitor.dart';

class UnionAssistContributor extends Object
    with AssistContributorMixin, ClassAstVisitorMixin
    implements AssistContributor {
  UnionAssistContributor(this.filePath);

  final String filePath;

  @override
  late final DartAssistRequest assistRequest;

  @override
  late final AssistCollector collector;

  AnalysisSession get session => assistRequest.result.session;

  @override
  Future<void> computeAssists(
    covariant DartAssistRequest request,
    AssistCollector collector,
  ) async {
    assistRequest = request;
    this.collector = collector;
    await _generateConstructor();
  }

  Future<void> _generateConstructor() async {
    final ClassDeclaration? classNode = findClassDeclaration();
    if (classNode == null || classNode.members.isEmpty || classNode.declaredElement == null) {
      return;
    }

    final ClassElement classElement = classNode.declaredElement!;

    final ElementAnnotation? unionElementAnnotation = classElement.metadata
        .firstWhereOrNull((ElementAnnotation annotation) => annotation.isUnionAnnotation);

    if (unionElementAnnotation == null) {
      return;
    }

    final UnionInternal unionInternalAnnotation =
        UnionInternal.fromDartObject(unionElementAnnotation.computeConstantValue());

    final RedirectedConstructorVisitor redirectedConstructorsVisitor =
        RedirectedConstructorVisitor(result: <String, RedirectedConstructor>{});
    classNode.visitChildren(redirectedConstructorsVisitor);

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);

    await changeBuilder.addDartFileEdit(
      filePath,
      (DartFileEditBuilder fileEditBuilder) {
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

        if (unionInternalAnnotation.fromJson) {
          _generateFromJsonFunction(
            classNode: classNode,
            classElement: classElement,
            fileEditBuilder: fileEditBuilder,
          );
        }

        if (unionInternalAnnotation.toJson) {
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
        );

        _generateGenerativeConstructor(
          classNode: classNode,
          classElement: classElement,
          fileEditBuilder: fileEditBuilder,
        );

        fileEditBuilder.format(SourceRange(classNode.offset, classNode.length));
      },
    );

    addAssist(AvailableAssists.union, changeBuilder);
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
  }) {
    for (final ConstructorElement ctor in classElement.constructors.reversed) {
      if (!ctor.isFactory || ctor.name.isEmpty) {
        continue;
      }

      final RedirectedConstructor redirectedCtor = redirectedConstructors[ctor.name]!;

      final ClassAstVisitor classVisitor = ClassAstVisitor(matcher: (ClassDeclaration node) {
        return redirectedCtor.name == node.name.lexeme;
      });
      assistRequest.result.unit.visitChildren(classVisitor);

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
    final SourceRange? sourceRange = classNode.members.getSourceRangeForMethod('fromJson');

    if (sourceRange == null) {
      fileEditBuilder.addInsertion(
        classNode.rightBracket.offset,
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
    final SourceRange? sourceRange = classNode.members.getSourceRangeForMethod('toJson');

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
  }) {
    // Contains default values of constructor parameters
    final Map<String, String> defaultValues = <String, String>{};

    final List<VariableElement> sharedFields = classElement.fields.where((FieldElement field) {
      return field.getter != null && field.getter!.isGetter && field.getter!.isAbstract;
    }).toList(growable: false);

    builder
      ..writeln('class $redirectedCtor extends ${classElement.thisType} {')
      ..writeln('const ${redirectedCtor.name}(');

    if (constructorElement.parameters.isNotEmpty) {
      builder.write('{');

      for (final ParameterElement param in constructorElement.parameters) {
        final ElementAnnotation? unionFieldValueAnnotation = param.metadata.firstWhereOrNull(
            (ElementAnnotation annotation) => annotation.isUnionFieldValueAnnotation);

        if (!param.type.isNullable && unionFieldValueAnnotation == null) {
          builder.write('required ');
        }

        builder.write('this.${param.name}');

        if (unionFieldValueAnnotation != null) {
          // toSource will provide a value like "@UnionFieldValue<User>(User(username: 'test'))"
          // so we extract everything between the first pair of parenthesis
          final String? extractedValue = RegExp(r'\((.*)\)')
              .firstMatch(unionFieldValueAnnotation.toSource())
              ?.group(1)
              ?.trim();

          if (extractedValue != null) {
            builder.write(' = ');

            // if the extractedValue contains a pair of parenthesis we assume
            // that this is an instance declaration so we prefix with const
            bool isConst = false;
            if (extractedValue.contains(RegExp(r'\(.*\)'))) {
              builder.write('const ');
              isConst = true;
            }
            builder.write(extractedValue);

            defaultValues[param.name] = '${isConst ? 'const' : ''} $extractedValue';
          }
        }

        builder.writeln(',');
      }

      builder.write('}');
    }

    builder
      ..writeln('): super._();')
      ..writeln();

    for (final ParameterElement param in constructorElement.parameters) {
      if (sharedFields.any((VariableElement field) => field.name == param.name)) {
        builder.writeln('@override');
      }
      builder.writeln('final ${param.type.typeStringValue()} ${param.name};');
    }

    if (unionInternalAnnotation.fromJson) {
      builder
        ..writeln()
        ..writeln('/// Creates an instance of [${redirectedCtor.name}] from [json]')
        ..writeln('factory ${redirectedCtor.name}.fromJson(Map<String, dynamic> json) {')
        ..writeln('return $redirectedCtor(');

      for (final ParameterElement param in constructorElement.parameters) {
        final ElementAnnotation? jsonKeyAnnotation = param.metadata
            .firstWhereOrNull((ElementAnnotation annotation) => annotation.isJsonKeyAnnotation);
        final JsonKeyInternal jsonKey = JsonKeyInternal //
            .fromDartObject(jsonKeyAnnotation?.computeConstantValue());

        if (jsonKey.ignore) {
          continue;
        }

        builder.write('${param.name}: ');

        if (jsonKey.fromJson != null) {
          builder
            ..write(jsonKey.fromJson!.fullyQualifiedName(
              enclosingImports: classElement.library.libraryImports,
            ))
            ..write('(json),');
          continue;
        }

        final String jsonFieldName = "json['${jsonKey.name ?? param.name}']";

        FromJsonGenerator(
          checkIfShouldUseFromJson: (DartType type) => false,
        ).run(
          nextType: param.type,
          builder: builder,
          depthIndex: 0,
          parentVariableName: jsonFieldName,
          defaultValue: defaultValues[param.name],
        );
      }

      builder
        ..writeln(');')
        ..writeln('}');
    }

    if (unionInternalAnnotation.toJson) {
      builder
        ..writeln()
        ..writeln('/// Converts [${redirectedCtor.name}] to a [Map] json')
        ..writeln('@override')
        ..writeln('Map<String, dynamic> toJson() {')
        ..writeln('return <String, dynamic>{');

      for (final ParameterElement param in constructorElement.parameters) {
        final ElementAnnotation? jsonKeyAnnotation = param.metadata
            .firstWhereOrNull((ElementAnnotation annotation) => annotation.isJsonKeyAnnotation);
        final JsonKeyInternal jsonKey = JsonKeyInternal //
            .fromDartObject(jsonKeyAnnotation?.computeConstantValue());

        if (jsonKey.ignore) {
          continue;
        }

        builder.write("'${jsonKey.name ?? param.name}': ");

        if (jsonKey.toJson != null) {
          builder
            ..write(jsonKey.toJson!
                .fullyQualifiedName(enclosingImports: classElement.library.libraryImports))
            ..write('(${param.name}),');
          continue;
        }

        ToJsonGenerator(
          checkIfShouldUseToJson: (DartType dartType) => false,
        ).run(
          nextType: param.type,
          builder: builder,
          parentVariableName: param.name,
          depthIndex: 0,
        );
      }

      builder
        ..writeln('};')
        ..writeln('}');
    }

    if (unionInternalAnnotation.dataClass) {
      CopyWithAssistContributor.writeCopyWith(
        className: '$redirectedCtor',
        commentClassName: redirectedCtor.name,
        fields: constructorElement.parameters,
        builder: builder,
      );

      HashAndEqualsAssistContributor.writeHashCode(
        fields: constructorElement.parameters,
        builder: builder,
      );

      HashAndEqualsAssistContributor.writeEquals(
        className: '$redirectedCtor',
        fields: constructorElement.parameters,
        builder: builder,
      );

      ToStringAssistContributor.writeToString(
        elementName: '$redirectedCtor',
        commentElementName: redirectedCtor.name,
        finalFieldsElements: constructorElement.parameters,
        builder: builder,
      );
    }

    builder.writeln('}');
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

      builder.writeln('required R Function($redirectedCtor value) ${ctor.name},');
    }

    builder.writeln('}) {');

    for (final ConstructorElement ctor in constructors) {
      final RedirectedConstructor? redirectedCtor = redirectedConstructors[ctor.name];

      if (redirectedCtor == null) {
        continue;
      }

      builder.writeln('if (this is $redirectedCtor) {'
          'return ${ctor.name}(this as $redirectedCtor);'
          '}');
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

      builder.writeln('R Function($redirectedCtor value)? ${ctor.name},');
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
          'return ${ctor.name}?.call(this as $redirectedCtor) ?? orElse();'
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
      ..writeln('${classElement.thisType} fromJson(Map<String, dynamic> json) {')
      ..writeln('// TODO: Implement')
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
