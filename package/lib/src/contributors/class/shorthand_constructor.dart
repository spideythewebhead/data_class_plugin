import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist_contributor_mixin.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/analyzer_plugin/analyzer_plugin.dart';
import 'package:data_class_plugin/src/contributors/available_assists.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/mixins.dart';

class ShorthandConstructorAssistContributor extends AssistContributorMixin
    with ClassAstVisitorMixin {
  ShorthandConstructorAssistContributor(this.filePath);

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
    try {
      assistRequest = request;
      this.collector = collector;
      await _generateConstructor();
    } catch (error, stackTrace) {
      debugTcpSocket?.writeln(error.toString());
      debugTcpSocket?.writeln(stackTrace.toString());
    }
  }

  Future<void> _generateConstructor() async {
    final ClassDeclaration? classNode = findClassDeclaration();
    if (classNode == null ||
        classNode.members.isEmpty ||
        classNode.declaredFragment == null ||
        classNode.declaredFragment!.element.metadata2.hasDataClassAnnotation ||
        classNode.declaredFragment!.element.metadata2.hasUnionAnnotation) {
      return;
    }

    final ClassElement2 classElement = classNode.declaredFragment!.element;
    final SourceRange? constructorSourceRange = classNode.members.defaultConstructorSourceRange;

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    await changeBuilder.addDartFileEdit(filePath, (
      DartFileEditBuilder fileEditBuilder,
    ) {
      void writerConstructor(DartEditBuilder builder) {
        writeConstructor(
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

      fileEditBuilder.format(SourceRange(classNode.offset, classNode.length));
    });

    addAssist(AvailableAssists.shorthandConstructor, changeBuilder);
  }

  static void writeConstructor({
    required final ClassElement2 classElement,
    required final DartEditBuilder builder,
    required List<ClassMember> members,
  }) {
    final ConstructorElement2? defaultConstructor = classElement.constructors2.firstWhereOrNull(
      (ConstructorElement2 e) => e.isDefaultConstructor,
    );
    final bool isConst = defaultConstructor?.isConst ?? true;

    final List<VariableElement2> fields = <VariableElement2>[
      ...classElement.dataClassFinalFields,
      ...classElement.chainSuperClassDataClassFinalFields,
    ];

    if (fields.isEmpty) {
      builder
        ..writeln()
        ..writeln('/// Shorthand constructor')
        ..writeln('${isConst ? 'const' : ''} ${classElement.name3}();');
      return;
    }

    String? initializerList;
    for (final ClassMember member in members) {
      if (member is ConstructorDeclaration &&
          member.name?.lexeme == null &&
          member.initializers.isNotEmpty) {
        initializerList = member.initializers.join(', ');
        break;
      }
    }

    builder
      ..writeln()
      ..writeln('/// Shorthand constructor')
      ..writeln('${isConst ? 'const' : ''} ${classElement.name3}({');

    void writeConstructorFieldsWithPrefix(
      String prefix,
      List<VariableElement2> fields,
    ) {
      for (final VariableElement2 field in fields) {
        final FormalParameterElement? existingParameter = defaultConstructor?.formalParameters
            .firstWhereOrNull((FormalParameterElement param) {
              return param.isNamed && param.name3 == field.name3;
            });

        String paramInitialization = '';
        if (existingParameter != null && existingParameter.hasDefaultValue) {
          paramInitialization = '= ${existingParameter.defaultValueCode}';
        }

        if (!field.type.isNullable && paramInitialization.isEmpty) {
          builder.write('required ');
        }

        builder.writeln('$prefix${field.name3} $paramInitialization,');
      }
    }

    final Set<String> superClassFinalFields = Set<String>.of(
      defaultConstructor?.dataClassSuperFields
              .map((FormalParameterElement field) => field.name3 ?? '')
              .toList(growable: false) ??
          const <String>[],
    );

    writeConstructorFieldsWithPrefix('super.', <FieldElement2>[
      // we need to exclude all the super fields that are already declared in the constructor
      for (final FieldElement2 field in classElement.chainSuperClassDataClassFinalFields)
        if (!superClassFinalFields.contains(field.name3)) field,
    ]);

    if (defaultConstructor != null) {
      // keep existing declarations of super.*
      for (final FormalParameterElement param in defaultConstructor.dataClassSuperFields) {
        builder
          ..write(param.isRequired ? 'required ' : '')
          ..write('super.${param.name3} ')
          ..write(param.hasDefaultValue ? '= ${param.defaultValueCode}' : '')
          ..writeln(',');
      }
    }

    writeConstructorFieldsWithPrefix(
      'this.',
      classElement.dataClassFinalFields,
    );

    builder.write('})');

    if (initializerList != null) {
      builder.write(': $initializerList');
    }

    builder.writeln(';');
  }
}
