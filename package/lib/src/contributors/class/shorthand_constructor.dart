import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
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
        classNode.declaredFragment!.element.metadata.hasDataClassAnnotation ||
        classNode.declaredFragment!.element.metadata.hasUnionAnnotation) {
      return;
    }

    final ClassElement classElement = classNode.declaredFragment!.element;
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
    required final ClassElement classElement,
    required final DartEditBuilder builder,
    required List<ClassMember> members,
  }) {
    final ConstructorElement? defaultConstructor = classElement.constructors.firstWhereOrNull(
      (ConstructorElement e) => e.isDefaultConstructor,
    );
    final bool isConst = defaultConstructor?.isConst ?? true;

    final List<VariableElement> fields = <VariableElement>[
      ...classElement.dataClassFinalFields,
      ...classElement.chainSuperClassDataClassFinalFields,
    ];

    if (fields.isEmpty) {
      builder
        ..writeln()
        ..writeln('/// Shorthand constructor')
        ..writeln('${isConst ? 'const' : ''} ${classElement.name}();');
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
      ..writeln('${isConst ? 'const' : ''} ${classElement.name}({');

    void writeConstructorFieldsWithPrefix(
      String prefix,
      List<VariableElement> fields,
    ) {
      for (final VariableElement field in fields) {
        final FormalParameterElement? existingParameter = defaultConstructor?.formalParameters
            .firstWhereOrNull((FormalParameterElement param) {
              return param.isNamed && param.name == field.name;
            });

        String paramInitialization = '';
        if (existingParameter != null && existingParameter.hasDefaultValue) {
          paramInitialization = '= ${existingParameter.defaultValueCode}';
        }

        if (!field.type.isNullable && paramInitialization.isEmpty) {
          builder.write('required ');
        }

        builder.writeln('$prefix${field.name} $paramInitialization,');
      }
    }

    final Set<String> superClassFinalFields = Set<String>.of(
      defaultConstructor?.dataClassSuperFields
              .map((FormalParameterElement field) => field.name ?? '')
              .toList(growable: false) ??
          const <String>[],
    );

    writeConstructorFieldsWithPrefix('super.', <FieldElement>[
      // we need to exclude all the super fields that are already declared in the constructor
      for (final FieldElement field in classElement.chainSuperClassDataClassFinalFields)
        if (!superClassFinalFields.contains(field.name)) field,
    ]);

    if (defaultConstructor != null) {
      // keep existing declarations of super.*
      for (final FormalParameterElement param in defaultConstructor.dataClassSuperFields) {
        builder
          ..write(param.isRequired ? 'required ' : '')
          ..write('super.${param.name} ')
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
