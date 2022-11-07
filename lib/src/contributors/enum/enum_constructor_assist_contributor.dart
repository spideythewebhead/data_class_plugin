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

class EnumConstructorAssistContributor extends Object
    with AssistContributorMixin, EnumAstVisitorMixin
    implements AssistContributor {
  EnumConstructorAssistContributor(this.filePath);

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
    final EnumDeclaration? enumNode = findEnumDeclaration();
    if (enumNode == null ||
        enumNode.members.isEmpty ||
        enumNode.declaredElement == null ||
        enumNode.semicolon == null) {
      return;
    }

    final EnumElement enumElement = enumNode.declaredElement!;
    final SourceRange? copyWithSourceRange = enumNode.members.getSourceRangeForConstructor(null);

    final List<FieldElement> finalFieldsElements = enumElement.fields.where((FieldElement field) {
      return field.isFinal && field.isPublic && !field.hasInitializer;
    }).toList(growable: false);

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    await changeBuilder.addDartFileEdit(
      filePath,
      (DartFileEditBuilder fileEditBuilder) {
        void writerConstructor(DartEditBuilder builder) {
          _writeConstructor(
            enumElement: enumElement,
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
            enumNode.semicolon!.charOffset + 1,
            writerConstructor,
          );
        }

        fileEditBuilder.format(SourceRange(enumNode.offset, enumNode.length));
      },
    );

    addAssist(AvailableAssists.enumConstructor, changeBuilder);
  }

  void _writeConstructor({
    required final EnumElement enumElement,
    required final List<FieldElement> finalFieldsElements,
    required final DartEditBuilder builder,
  }) {
    builder
      ..writeln()
      ..writeln('/// Default constructor of [${enumElement.name}]')
      ..writeln('const ${enumElement.name}(');

    for (final FieldElement field in finalFieldsElements) {
      builder.write('this.${field.name}');
      if (finalFieldsElements.length > 1) {
        builder.writeln(',');
      }
    }

    builder.writeln(');');
  }
}