import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist_contributor_mixin.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/contributors/available_assists.dart';
import 'package:data_class_plugin/src/extensions.dart';
import 'package:data_class_plugin/src/mixins.dart';

class ShorthandConstructorAssistContributor extends Object
    with AssistContributorMixin, ClassAstVisitorMixin
    implements AssistContributor {
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
    assistRequest = request;
    this.collector = collector;
    await _generateConstructor();
  }

  Future<void> _generateConstructor() async {
    final ClassDeclaration? classNode = findClassDeclaration();
    if (classNode == null ||
        classNode.members.isEmpty ||
        classNode.declaredElement == null) {
      return;
    }

    final ClassElement classElement = classNode.declaredElement!;
    final SourceRange? copyWithSourceRange =
        classNode.members.getSourceRangeForConstructor(null);

    final List<FieldElement> finalFieldsElements =
        classElement.fields.where((FieldElement field) {
      return field.isFinal && field.isPublic && !field.hasInitializer;
    }).toList(growable: false);

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    await changeBuilder.addDartFileEdit(
      filePath,
      (DartFileEditBuilder fileEditBuilder) {
        void writerConstructor(DartEditBuilder builder) {
          _writeConstructor(
            classElement: classElement,
            finalFieldsElements: finalFieldsElements,
            builder: builder,
          );
        }

        if (copyWithSourceRange != null) {
          fileEditBuilder.addReplacement(
            copyWithSourceRange,
            writerConstructor,
          );
        } else {
          fileEditBuilder.addInsertion(
            classNode.leftBracket.offset + 1,
            writerConstructor,
          );
        }

        fileEditBuilder.format(SourceRange(classNode.offset, classNode.length));
      },
    );

    addAssist(AvailableAssists.shorthandConstructor, changeBuilder);
  }

  void _writeConstructor({
    required final ClassElement classElement,
    required final List<FieldElement> finalFieldsElements,
    required final DartEditBuilder builder,
  }) {
    final ConstructorElement? constructor = classElement.constructors
        .firstWhereOrNull((ConstructorElement ctor) => ctor.name.isEmpty);
    final bool isConstructor = constructor?.isConst ?? true;

    builder
      ..writeln()
      ..writeln('/// Shorthand constructor')
      ..writeln('${isConstructor ? 'const' : ''} ${classElement.name}({');

    for (final FieldElement field in finalFieldsElements) {
      final ParameterElement? existingParameter =
          constructor?.parameters.firstWhereOrNull((ParameterElement param) {
        return param.isNamed && param.name == field.name;
      });

      String paramInitialization = '';
      if (existingParameter != null && existingParameter.hasDefaultValue) {
        paramInitialization = ' = ${existingParameter.defaultValueCode}';
      }

      if (!field.type.isNullable && paramInitialization.isEmpty) {
        builder.write('required');
      }

      builder.writeln(' this.${field.name} $paramInitialization,');
    }

    builder.writeln('});');
  }
}
