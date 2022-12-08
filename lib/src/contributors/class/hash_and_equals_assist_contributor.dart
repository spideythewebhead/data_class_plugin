import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist_contributor_mixin.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/contributors/available_assists.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/mixins.dart';

class HashAndEqualsAssistContributor extends Object
    with AssistContributorMixin, ClassAstVisitorMixin
    implements AssistContributor {
  HashAndEqualsAssistContributor(this.filePath);

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
    await _generateHashAndEquals();
  }

  Future<void> _generateHashAndEquals() async {
    final ClassDeclaration? classNode = findClassDeclaration();
    if (classNode == null || classNode.members.isEmpty || classNode.declaredElement == null) {
      return;
    }

    final ClassElement classElement = classNode.declaredElement!;

    if (classElement.hasUnionAnnotation) {
      return;
    }

    final SourceRange? equalsSourceRange = classNode.members.getSourceRangeForMethod('==');
    final SourceRange? hashCodeSourceRange = classNode.members.getSourceRangeForMethod('hashCode');

    final List<FieldElement> fields = <FieldElement>[
      ...classElement.dataClassFinalFields,
      ...classElement.chainSuperClassDataClassFinalFields,
    ];

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    await changeBuilder.addDartFileEdit(
      filePath,
      (DartFileEditBuilder fileEditBuilder) {
        void writerHashCode(DartEditBuilder builder) {
          writeHashCode(
            fields: fields,
            builder: builder,
          );
        }

        if (hashCodeSourceRange != null) {
          fileEditBuilder.addReplacement(hashCodeSourceRange, writerHashCode);
        } else {
          fileEditBuilder.addInsertion(classNode.rightBracket.offset, writerHashCode);
        }

        void writerEquals(DartEditBuilder builder) {
          writeEquals(
            fields: fields,
            className: classElement.thisType.toString(),
            builder: builder,
          );
        }

        if (equalsSourceRange != null) {
          fileEditBuilder.addReplacement(equalsSourceRange, writerEquals);
        } else {
          fileEditBuilder.addInsertion(classNode.rightBracket.offset, writerEquals);
        }

        fileEditBuilder.format(SourceRange(classNode.offset, classNode.length));
      },
    );

    addAssist(AvailableAssists.hashCodeAndEquals, changeBuilder);
  }

  static void writeHashCode({
    required final List<Element> fields,
    required final DartEditBuilder builder,
  }) {
    builder
      ..writeln()
      ..writeln('/// Returns a hash code based on [this] properties')
      ..writeln('@override')
      ..writeln('int get hashCode {')
      ..writeln('return Object.hashAll(<Object?>[')
      ..writeln('runtimeType');

    for (final Element field in fields) {
      builder.writeln(',${field.name}');
    }

    builder
      ..writeln(',]);')
      ..writeln('}');
  }

  static void writeEquals({
    required final List<VariableElement> fields,
    required final String className,
    required final DartEditBuilder builder,
  }) {
    builder
      ..writeln()
      ..writeln('/// Compares [this] with [other] on identity, class type, and properties')
      ..writeln('/// *with deep comparison on collections*')
      ..writeln('@override')
      ..writeln('bool operator ==(Object other) {')
      ..writeln('return identical(this, other) || other is $className');

    for (final VariableElement field in fields) {
      if (field.type.isDartCoreList || field.type.isDartCoreMap || field.type.isDartCoreSet) {
        builder.write(' && deepEquality(${field.name}, other.${field.name})');
      } else {
        builder.write(' && ${field.name} == other.${field.name}');
      }
    }

    builder
      ..write(';')
      ..writeln('}');
  }
}
