import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/annotations/constants.dart';
import 'package:data_class_plugin/src/annotations/data_class_internal.dart';
import 'package:data_class_plugin/src/backend/core/custom_dart_type.dart';
import 'package:data_class_plugin/src/common/utils.dart';
import 'package:data_class_plugin/src/contributors_delegates/class_generation_delegate.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';

class FileGenerationDataClassDelegate extends ClassGenerationDelegate {
  FileGenerationDataClassDelegate({
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
    final DataClassInternal dataClassAnnotation = DataClassInternal.fromDartObject(
      classElement.metadata.dataClassAnnotation!.computeConstantValue(),
    );

    final SourceRange? constructorSourceRange = classNode.members.defaultConstructorSourceRange;
    final SourceRange? copyWithSourceRange = classNode.members.copyWithSourceRange;
    final SourceRange? fromJsonSourceRange = classNode.members.fromJsonSourceRange;
    final SourceRange? toJsonSourceRange = classNode.members.toJsonSourceRange;

    final List<FieldElement> fields = classElement.fields.where((FieldElement field) {
      return field.getter != null &&
          field.getter!.name != 'hashCode' &&
          field.getter!.isGetter &&
          field.getter!.isAbstract;
    }).toList(growable: false);

    await changeBuilder.addDartFileEdit(targetFilePath, (DartFileEditBuilder fileEditBuilder) {
      if (!classElement.isAbstract) {
        fileEditBuilder.addInsertion(
          classNode.classKeyword.offset,
          (DartEditBuilder builder) {
            builder.write('abstract ');
          },
        );
      }

      final List<FieldDeclaration> finalFieldsDeclarations = classNode.members
          .where((ClassMember member) {
            return member is FieldDeclaration && member.fields.isFinal;
          })
          .toList(growable: false)
          .cast<FieldDeclaration>();

      _updateFinalFieldsToGetters(
        finalFieldsDeclarations: finalFieldsDeclarations,
        fileEditBuilder: fileEditBuilder,
      );

      addPartDirective(
        classElement: classElement,
        directives: compilationUnit.directives,
        fileEditBuilder: fileEditBuilder,
        targetFilePath: targetFilePath,
      );

      void createFactoryConstructor(DartEditBuilder builder) {
        _createFactoryConstructor(
          classElement: classElement,
          builder: builder,
          fields: fields,
          finalFieldsDeclarations: finalFieldsDeclarations,
        );
      }

      if (constructorSourceRange != null) {
        fileEditBuilder.addReplacement(
          constructorSourceRange,
          createFactoryConstructor,
        );
      } else {
        fileEditBuilder.addInsertion(
          classNode.leftBracket.offset + 1,
          createFactoryConstructor,
        );
      }

      if (dataClassAnnotation.fromJson ??
          pluginOptions.dataClass.effectiveFromJson(relativeFilePath)) {
        void createFromJson(DartEditBuilder builder) {
          _createFromJson(
            classElement: classElement,
            builder: builder,
          );
        }

        if (fromJsonSourceRange != null) {
          fileEditBuilder.addReplacement(fromJsonSourceRange, createFromJson);
        } else {
          fileEditBuilder.addInsertion(
            classNode.rightBracket.offset,
            createFromJson,
          );
        }
      } else if (fromJsonSourceRange != null) {
        fileEditBuilder.addDeletion(fromJsonSourceRange);
      }

      if (dataClassAnnotation.copyWith ??
          pluginOptions.dataClass.effectiveCopyWith(relativeFilePath)) {
        void createCopyWith(DartEditBuilder builder) {
          _createCopyWith(
            classElement: classElement,
            fields: fields,
            builder: builder,
          );
        }

        if (copyWithSourceRange != null) {
          fileEditBuilder.addReplacement(copyWithSourceRange, createCopyWith);
        } else {
          fileEditBuilder.addInsertion(
            classNode.rightBracket.offset,
            createCopyWith,
          );
        }
      } else if (copyWithSourceRange != null) {
        fileEditBuilder.addDeletion(copyWithSourceRange);
      }

      if (dataClassAnnotation.toJson ?? pluginOptions.dataClass.effectiveToJson(relativeFilePath)) {
        void createToJson(DartEditBuilder builder) {
          _createToJson(
            className: classElement.name,
            builder: builder,
          );
        }

        if (toJsonSourceRange != null) {
          fileEditBuilder.addReplacement(toJsonSourceRange, createToJson);
        } else {
          fileEditBuilder.addInsertion(
            classNode.rightBracket.offset,
            createToJson,
          );
        }
      } else if (toJsonSourceRange != null) {
        fileEditBuilder.addDeletion(toJsonSourceRange);
      }

      fileEditBuilder.format(SourceRange(classNode.offset, classNode.length));
    });
  }

  void _updateFinalFieldsToGetters({
    required List<FieldDeclaration> finalFieldsDeclarations,
    required DartFileEditBuilder fileEditBuilder,
  }) {
    final List<FormalParameter> formalParameters =
        (classNode.members.firstWhereOrNull((ClassMember member) {
              return member is ConstructorDeclaration && member.name?.lexeme == null;
            }) as ConstructorDeclaration?)
                ?.parameters
                .parameters
                .where((FormalParameter parameter) => parameter.isNamed)
                .toList(growable: false) ??
            const <FormalParameter>[];

    for (final FieldDeclaration fieldDeclaration in finalFieldsDeclarations) {
      fileEditBuilder.addReplacement(
        SourceRange(fieldDeclaration.offset, fieldDeclaration.length),
        (DartEditBuilder builder) {
          for (final VariableDeclaration variableDeclaration in fieldDeclaration.fields.variables) {
            final Annotation? jsonKeyAnnotation =
                fieldDeclaration.metadata.getAnnotation(AnnotationType.jsonKey);

            if (jsonKeyAnnotation != null) {
              builder.writeln(jsonKeyAnnotation.toSource());
            }

            final FormalParameter? matchedFormalParameter =
                formalParameters.firstWhereOrNull((FormalParameter parameter) {
              return parameter.name?.lexeme == variableDeclaration.name.lexeme;
            });

            if (matchedFormalParameter is DefaultFormalParameter &&
                matchedFormalParameter.defaultValue != null &&
                matchedFormalParameter.defaultValue!.toSource() != 'null') {
              final String? defaultValueExpression =
                  matchedFormalParameter.defaultValue?.toSource().replaceFirst('const', '');

              builder.writeln('@DefaultValue($defaultValueExpression)');
            }

            builder.writeln(
                '${fieldDeclaration.fields.type?.toSource() ?? 'dynamic'} get ${variableDeclaration.name.lexeme};');
          }
        },
      );
    }
  }

  void _createFactoryConstructor({
    required final ClassElement classElement,
    required final DartEditBuilder builder,
    required final List<FieldElement> fields,
    required final List<FieldDeclaration> finalFieldsDeclarations,
  }) {
    final ConstructorElement? defaultConstructor = classElement.defaultConstructor;
    final String optionalTypeParameters =
        classElement.typeParameters.join(', ').wrapWithAngleBracketsIfNotEmpty();
    final bool isConst = defaultConstructor?.isConst ?? true;

    builder
      ..writeln()
      ..writeln('/// Default constructor')
      ..writeln('${isConst ? 'const' : ''} factory ${classElement.name}(');

    if (fields.isNotEmpty || finalFieldsDeclarations.isNotEmpty) {
      builder.write('{');
    }

    for (final FieldDeclaration fieldDeclaration in finalFieldsDeclarations) {
      final CustomDartType customDartType = fieldDeclaration.fields.type.customDartType;
      if (!(customDartType.isDynamic || customDartType.isNullable)) {
        builder.write('required');
      }
      for (final VariableDeclaration variableDeclaration in fieldDeclaration.fields.variables) {
        builder.writeln(' ${customDartType.fullTypeName} ${variableDeclaration.name.lexeme},');
      }
    }

    for (final FieldElement field in fields) {
      if (!(field.type.isDynamic ||
          field.type.isNullable ||
          field.getter!.hasDefaultValueAnnotation)) {
        builder.write('required');
      }

      builder
        ..write(
            ' ${field.type.typeStringValue(enclosingImports: classElement.library.libraryImports)}')
        ..writeln(' ${field.name},');
    }

    if (fields.isNotEmpty || finalFieldsDeclarations.isNotEmpty) {
      builder.write('}');
    }

    builder.writeln(') = _\$${classElement.name}Impl$optionalTypeParameters;');
  }

  void _createCopyWith({
    required final ClassElement classElement,
    required final List<VariableElement> fields,
    required final DartEditBuilder builder,
  }) {
    builder
      ..writeln()
      ..writeln('/// Creates a new instance of [${classElement.name}] with optional new values')
      ..writeln('${classElement.thisType} copyWith(');

    if (fields.isNotEmpty) {
      builder.write('{');

      for (final VariableElement field in fields) {
        final String typeStringValue =
            field.type.typeStringValue(enclosingImports: classElement.library.libraryImports);
        final bool isNullable = typeStringValue.endsWith('?');
        builder.writeln('final $typeStringValue${isNullable ? '' : '?'} ${field.name},');
      }

      builder.write('}');
    }

    builder.writeln(');');
  }

  void _createFromJson({
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
          'factory $className.fromJson(Map<dynamic, dynamic> json) = _\$${className}Impl$optionalTypeParameters.fromJson;');
  }

  void _createToJson({
    required final String className,
    required final DartEditBuilder builder,
  }) {
    builder
      ..writeln()
      ..writeln('/// Converts [$className] to a [Map] json')
      ..writeln('Map<String, dynamic> toJson();');
  }
}
