import 'package:analyzer/dart/ast/ast.dart';
import 'package:data_class_plugin/src/backend/core/custom_dart_object.dart';
import 'package:data_class_plugin/src/backend/core/declaration_info.dart';
import 'package:data_class_plugin/src/common/code_writer.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';

void createConstructor({
  required final CodeWriter codeWriter,
  required final ConstructorDeclaration? constructor,
  required final List<DeclarationInfo> fields,
  required final String generatedClassName,
  final bool shouldAnnotateFieldsWithOverride = true,
  final String? superConstructorName,
}) {
  codeWriter.write(constructor?.constKeyword?.lexeme ?? '');
  codeWriter.write(' $generatedClassName(');

  if (fields.isNotEmpty) {
    codeWriter.write('{');
    for (final DeclarationInfo field in fields) {
      final Annotation? defaultValueAnnotation = field.metadata
          .firstWhereOrNull((Annotation annotation) => annotation.isDefaultValueAnnotation);

      Expression? defaultValueExpression;
      late String defaultValuePrefix;

      if (defaultValueAnnotation != null) {
        final AnnotationValueExtractor annotationValueExtractor =
            AnnotationValueExtractor(defaultValueAnnotation);
        defaultValueExpression = annotationValueExtractor.getPositionedArgument(0);
      }
      defaultValuePrefix =
          (defaultValueExpression is TypedLiteral || defaultValueExpression is MethodInvocation)
              ? 'const'
              : '';

      if (field.isRequired) {
        codeWriter.write('required ');
      }
      codeWriter
        ..write('this.${field.name}')
        ..write(defaultValueExpression != null
            ? ' = $defaultValuePrefix ${defaultValueExpression.toSource()}'
            : '')
        ..write(',');
    }
    codeWriter.write('}');
  }

  codeWriter
    ..writeln('): super.${superConstructorName ?? 'ctor'}();')
    ..writeln();

  for (final DeclarationInfo field in fields) {
    codeWriter
      ..writeln(shouldAnnotateFieldsWithOverride ? '@override' : '')
      ..writeln('final ${field.type?.toSource() ?? 'dynamic'} ${field.name};')
      ..writeln();
  }

  codeWriter.writeln();
}
