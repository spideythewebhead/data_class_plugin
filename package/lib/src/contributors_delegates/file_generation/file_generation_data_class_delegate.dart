import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/annotations/constants.dart';
import 'package:data_class_plugin/src/annotations/data_class_internal.dart';
import 'package:data_class_plugin/src/common/utils.dart';
import 'package:data_class_plugin/src/contributors_delegates/class_generation_delegate.dart';
import 'package:data_class_plugin/src/exceptions.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:tachyon/tachyon.dart';

class FileGenerationDataClassDelegate extends ClassGenerationDelegate {
  FileGenerationDataClassDelegate({
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
    await changeBuilder.addDartFileEdit(targetFilePath, (
      DartFileEditBuilder fileEditBuilder,
    ) {
      for (final ClassDeclaration classNode in classNodes) {
        final ClassElement2 classElement = classNode.declaredFragment!.element;

        final ElementAnnotation? dataClassElementAnnotation =
            classElement.metadata2.dataClassAnnotation;
        if (dataClassElementAnnotation == null) {
          throw DcpException.missingDataClassPluginImport(
            relativeFilePath: relativeFilePath,
          );
        }

        final DataClassInternal dataClassAnnotation = DataClassInternal.fromDartObject(
          dataClassElementAnnotation.computeConstantValue(),
        );

        final SourceRange? constructorSourceRange = classNode.members.defaultConstructorSourceRange;
        final SourceRange? fromJsonSourceRange = classNode.members.fromJsonSourceRange;
        final SourceRange? toJsonSourceRange = classNode.members.toJsonSourceRange;

        final List<FieldElement2> fields = classElement.fields2
            .where((FieldElement2 field) {
              final GetterElement? getter = field.getter2;
              return getter != null &&
                  getter.name3 != 'hashCode' &&
                  // getter.isGetter &&
                  getter.isAbstract;
            })
            .toList(growable: false);

        final List<FieldDeclaration> finalFieldsDeclarations = classNode.members
            .whereType<FieldDeclaration>()
            .where((FieldDeclaration field) {
              if (!field.fields.isFinal || field.fields.variables.length != 1) {
                return false;
              }
              final VariableDeclaration finalField = field.fields.variables[0];
              if (finalField.name.lexeme[0] == '_' || finalField.initializer != null) {
                return false;
              }
              return true;
            })
            .toList(growable: false);

        final Set<String> classFieldsNames = <String>{
          for (final FieldElement2 field in fields) field.name3!,
        };

        final List<FieldElement2> superClassFields;

        if (classElement.supertype?.element3 is ClassElement2 &&
            (classElement.supertype?.element3.metadata2.hasDataClassAnnotation ?? false)) {
          final ClassElement2 superClass = classElement.supertype?.element3 as ClassElement2;
          superClassFields = superClass.fields2
              .where((FieldElement2 field) {
                final GetterElement? getter = field.getter2;
                return getter != null &&
                    getter.name3 != 'hashCode' &&
                    // getter.isGetter &&
                    getter.isAbstract &&
                    !classFieldsNames.contains(field.name3);
              })
              .toList(growable: false);
        } else {
          superClassFields = const <FieldElement2>[];
        }

        if (!classElement.isAbstract) {
          fileEditBuilder.addInsertion(classNode.classKeyword.offset, (
            DartEditBuilder builder,
          ) {
            builder.write('abstract ');
          });
        }

        void createDefaultConstructor(DartEditBuilder builder) {
          _createDefaultConstructor(
            classElement: classElement,
            builder: builder,
            constructorName: dataClassAnnotation.constructorName ?? 'ctor',
          );
        }

        final SourceRange? defaultConstructorSourceRange = classNode.members
            .getSourceRangeForConstructor(
              dataClassAnnotation.constructorName ?? 'ctor',
            );

        if (defaultConstructorSourceRange != null) {
          fileEditBuilder.addReplacement(
            defaultConstructorSourceRange,
            createDefaultConstructor,
          );
        } else {
          fileEditBuilder.addInsertion(
            classNode.leftBracket.offset + 1,
            createDefaultConstructor,
          );
        }

        _updateFinalFieldsToGetters(
          classNode: classNode,
          finalFieldsDeclarations: finalFieldsDeclarations,
          fileEditBuilder: fileEditBuilder,
        );

        void createFactoryConstructor(DartEditBuilder builder) {
          _createFactoryConstructor(
            classElement: classElement,
            builder: builder,
            fields: fields,
            superClassFields: superClassFields,
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

        if (superClassFields.isNotEmpty) {
          _writeSuperClassFields(
            classElement: classElement,
            classNode: classNode,
            constructorSourceRange: constructorSourceRange,
            fileEditBuilder: fileEditBuilder,
            superClassFields: superClassFields,
          );
        }

        if (dataClassAnnotation.fromJson ??
            pluginOptions.dataClass.effectiveFromJson(relativeFilePath)) {
          if (fromJsonSourceRange == null) {
            fileEditBuilder.addInsertion(classNode.rightBracket.offset, (
              DartEditBuilder builder,
            ) {
              _createFromJson(classElement: classElement, builder: builder);
            });
          }
        } else if (fromJsonSourceRange != null && pluginOptions.autoDeleteCodeFromAnnotation) {
          fileEditBuilder.addDeletion(fromJsonSourceRange);
        }

        if (dataClassAnnotation.toJson ??
            pluginOptions.dataClass.effectiveToJson(relativeFilePath)) {
          if (toJsonSourceRange == null) {
            fileEditBuilder.addInsertion(classNode.rightBracket.offset, (
              DartEditBuilder builder,
            ) {
              _createToJson(classElement: classElement, builder: builder);
            });
          }
        } else if (toJsonSourceRange != null && pluginOptions.autoDeleteCodeFromAnnotation) {
          fileEditBuilder.addDeletion(toJsonSourceRange);
        }

        fileEditBuilder.format(SourceRange(classNode.offset, classNode.length));
      }

      addPartDirective(
        // partElements: classNodes[0].declaredElement!.library.parts,
        partElements: classNodes[0].declaredFragment!.libraryFragment.partIncludes,
        directives: compilationUnit.directives,
        fileEditBuilder: fileEditBuilder,
        targetFilePath: targetFilePath,
      );
    });
  }

  void _writeSuperClassFields({
    required final ClassElement2 classElement,
    required final SourceRange? constructorSourceRange,
    required final DartFileEditBuilder fileEditBuilder,
    required final List<FieldElement2> superClassFields,
    required final ClassDeclaration classNode,
  }) {
    final int offset;

    if (constructorSourceRange != null) {
      offset = 1 + constructorSourceRange.offset + constructorSourceRange.length;
    } else {
      offset = 1 + classNode.leftBracket.offset;
    }

    fileEditBuilder.addInsertion(offset, (DartEditBuilder builder) {
      builder.writeln();

      for (final FieldElement2 field in superClassFields) {
        final Metadata getterMetadata = field.getter2!.metadata2;

        builder.writeln('@override');

        if (getterMetadata.hasDefaultValueAnnotation) {
          builder.writeln(getterMetadata.defaultValueAnnotation!.toSource());
        }

        if (getterMetadata.hasJsonKeyAnnotation) {
          builder.writeln(getterMetadata.jsonKeyAnnotation!.toSource());
        }

        builder
          ..writeln(
            '${field.type.typeStringValue(enclosingImports: compilationUnit.declaredFragment!.libraryImports2)} get ${field.name3};',
          )
          ..writeln();
      }
    });
  }

  void _createDefaultConstructor({
    required final ClassElement2 classElement,
    required final DartEditBuilder builder,
    required final String constructorName,
  }) {
    final ConstructorElement2? defaultConstructor = classElement.defaultConstructor;
    final bool isConst = defaultConstructor?.isConst ?? true;
    builder
      ..writeln()
      ..writeln(
        '${isConst ? 'const' : ''} ${classElement.name3}.$constructorName()',
      );

    if (classElement.supertype != null) {
      final ConstructorElement2? emptyCtor = classElement.supertype?.constructors2.firstWhereOrNull(
        (ConstructorElement2 ctor) => !ctor.isFactory && ctor.formalParameters.isEmpty,
      );

      if (emptyCtor case ConstructorElement2(
        :final String? name3,
      ) when name3 != null && name3.isNotEmpty && name3 != 'new') {
        builder.write(': super.${emptyCtor.name3}()');
      }
    }

    builder
      ..writeln(';')
      ..writeln();
  }

  void _updateFinalFieldsToGetters({
    required final ClassDeclaration classNode,
    required final List<FieldDeclaration> finalFieldsDeclarations,
    required final DartFileEditBuilder fileEditBuilder,
  }) {
    final List<FormalParameter> formalParameters =
        (classNode.members.firstWhereOrNull((ClassMember member) {
                  return member is ConstructorDeclaration && member.name?.lexeme == null;
                })
                as ConstructorDeclaration?)
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
            final Annotation? jsonKeyAnnotation = fieldDeclaration.metadata.getAnnotation(
              AnnotationType.jsonKey,
            );

            if (jsonKeyAnnotation != null) {
              builder.writeln(jsonKeyAnnotation.toSource());
            }

            final FormalParameter? matchedFormalParameter = formalParameters.firstWhereOrNull((
              FormalParameter parameter,
            ) {
              return parameter.name?.lexeme == variableDeclaration.name.lexeme;
            });

            if (matchedFormalParameter is DefaultFormalParameter &&
                matchedFormalParameter.defaultValue != null &&
                matchedFormalParameter.defaultValue!.toSource() != 'null') {
              final String? defaultValueExpression = matchedFormalParameter.defaultValue
                  ?.toSource()
                  .replaceFirst('const', '');

              builder.writeln('@DefaultValue($defaultValueExpression)');
            }

            builder.writeln(
              '${fieldDeclaration.fields.type?.toSource() ?? 'dynamic'} get ${variableDeclaration.name.lexeme};',
            );
          }
        },
      );
    }
  }

  void _createFactoryConstructor({
    required final ClassElement2 classElement,
    required final DartEditBuilder builder,
    required final List<FieldElement2> fields,
    required final List<FieldElement2> superClassFields,
    required final List<FieldDeclaration> finalFieldsDeclarations,
  }) {
    final ConstructorElement2? defaultConstructor = classElement.defaultConstructor;
    final String optionalTypeParameters = classElement.typeParameters2
        .map((TypeParameterElement2 parameter) => parameter.name3)
        .nonNulls
        .join(', ')
        .wrapWithAngleBracketsIfNotEmpty();
    final bool isConst = defaultConstructor?.isConst ?? true;

    builder
      ..writeln()
      ..writeln('/// Default constructor')
      ..writeln('${isConst ? 'const' : ''} factory ${classElement.name3}(');

    final bool shouldAddBrace =
        fields.isNotEmpty || finalFieldsDeclarations.isNotEmpty || superClassFields.isNotEmpty;

    if (shouldAddBrace) {
      builder.write('{');
    }

    for (final FieldDeclaration fieldDeclaration in finalFieldsDeclarations) {
      final TachyonDartType dartType = fieldDeclaration.fields.type.customDartType;
      if (!(dartType.isDynamic || dartType.isNullable)) {
        builder.write('required');
      }
      for (final VariableDeclaration variableDeclaration in fieldDeclaration.fields.variables) {
        builder.writeln(
          ' ${dartType.fullTypeName} ${variableDeclaration.name.lexeme},',
        );
      }
    }

    for (final FieldElement2 field in <FieldElement2>[
      ...superClassFields,
      ...fields,
    ]) {
      if (!(field.type is DynamicType ||
          field.type.isNullable ||
          field.getter2!.metadata2.hasDefaultValueAnnotation)) {
        builder.write('required');
      }

      builder
        ..write(
          ' ${field.type.typeStringValue(enclosingImports: compilationUnit.declaredFragment!.libraryImports2)}',
        )
        ..writeln(' ${field.name3},');
    }

    if (shouldAddBrace) {
      builder.write('}');
    }

    builder.writeln(') = _\$${classElement.name3}Impl$optionalTypeParameters;');
  }

  void _createFromJson({
    required final ClassElement2 classElement,
    required final DartEditBuilder builder,
  }) {
    final String className = classElement.name3!;
    final String optionalTypeParameters = classElement.typeParameters2
        .map((TypeParameterElement2 parameter) => parameter.name3)
        .nonNulls
        .join(', ')
        .wrapWithAngleBracketsIfNotEmpty();
    builder
      ..writeln()
      ..writeln('/// Creates an instance of [$className] from [json]')
      ..writeln(
        'factory $className.fromJson(Map<dynamic, dynamic> json) = _\$${className}Impl$optionalTypeParameters.fromJson;',
      );
  }

  void _createToJson({
    required final ClassElement2 classElement,
    required final DartEditBuilder builder,
  }) {
    final bool shouldAnnotateWithOverride =
        <InterfaceType>[
          ...classElement.interfaces,
          ...classElement.allSupertypes,
        ].any((InterfaceType element) {
          return element //
              .methods2
              .any((MethodElement2 element) => element.name3 == 'toJson');
        });

    builder.writeln('/// Converts [${classElement.name3}] to a [Map] json');

    if (shouldAnnotateWithOverride) {
      builder.writeln('@override');
    }

    builder.writeln('Map<String, dynamic> toJson();');
  }
}
