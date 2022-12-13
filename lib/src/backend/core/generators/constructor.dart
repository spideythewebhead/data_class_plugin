import 'package:analyzer/dart/ast/ast.dart';
import 'package:data_class_plugin/src/backend/core/custom_dart_object.dart';
import 'package:data_class_plugin/src/common/code_writer.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';

void createConstructor({
  required final CodeWriter codeWriter,
  required final ConstructorDeclaration? defaultConstructor,
  required final List<MethodDeclaration> fields,
  required final String generatedClassName,
}) {
  final List<FormalParameter> parameters = defaultConstructor?.parameters.parameters
          .where((FormalParameter parameter) => parameter.isNamed)
          .toList(growable: false) ??
      <FormalParameter>[];

  codeWriter.write(defaultConstructor?.constKeyword?.lexeme ?? '');
  codeWriter.write(' $generatedClassName(');

  if (parameters.isNotEmpty) {
    codeWriter.write('{');
    for (final FormalParameter parameter in parameters) {
      final Annotation? defaultValueAnnotation = fields
          .firstWhereOrNull(
              (MethodDeclaration field) => field.name.lexeme == parameter.name?.lexeme)
          ?.metadata
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

      if (parameter.isRequired) {
        codeWriter.write('required ');
      }
      codeWriter
        ..write('this.${parameter.name!.lexeme}')
        ..write(defaultValueExpression != null
            ? ' = $defaultValuePrefix ${defaultValueExpression.toSource()}'
            : '')
        ..write(',');
    }
    codeWriter.write('}');
  }

  codeWriter
    ..writeln('): super._();')
    ..writeln();

  for (final MethodDeclaration field in fields) {
    codeWriter
      ..writeln('@override')
      ..writeln('final ${field.returnType?.toSource() ?? 'dynamic'} ${field.name.lexeme};')
      ..writeln();
  }

  codeWriter.writeln();
}
