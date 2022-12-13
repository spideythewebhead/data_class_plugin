import 'package:analyzer/dart/ast/ast.dart';
import 'package:data_class_plugin/src/annotations/constants.dart';
import 'package:data_class_plugin/src/backend/core/custom_dart_object.dart';
import 'package:data_class_plugin/src/backend/core/generators/generator.dart';
import 'package:data_class_plugin/src/common/code_writer.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';

class UnionFromJsonGenerator implements Generator {
  UnionFromJsonGenerator({
    required CodeWriter codeWriter,
    required String className,
    required String classTypeParametersSource,
    required List<ConstructorDeclaration> factoriesWithRedirectedConstructors,
    required AnnotationValueExtractor unionAnnotationValueExtractor,
  })  : _codeWriter = codeWriter,
        _className = className,
        _classTypeParametersSource = classTypeParametersSource,
        _factoriesWithRedirectedConstructors = factoriesWithRedirectedConstructors,
        _unionAnnotationValueExtractor = unionAnnotationValueExtractor;

  final CodeWriter _codeWriter;
  final String _className;
  final String _classTypeParametersSource;
  final List<ConstructorDeclaration> _factoriesWithRedirectedConstructors;
  final AnnotationValueExtractor _unionAnnotationValueExtractor;

  @override
  void execute() {
    final String? unionJsonKey = _unionAnnotationValueExtractor.getString('unionJsonKey');

    final String? unionFallbackJsonValue =
        _unionAnnotationValueExtractor.getString('unionFallbackJsonValue');
    String? defaultFallbackConstructor;

    _codeWriter
      ..writeln(
          '$_className$_classTypeParametersSource _\$${_className}FromJson$_classTypeParametersSource(Map<dynamic, dynamic> json) {')
      ..writeln("switch (json['$unionJsonKey']) {");

    for (final ConstructorDeclaration ctor in _factoriesWithRedirectedConstructors) {
      String? jsonKeyValue =
          AnnotationValueExtractor(ctor.metadata.getAnnotation(AnnotationType.unionJsonKeyValue))
              .getPositionedArgument(0)
              ?.toSource();

      if (ctor.name!.lexeme == unionFallbackJsonValue) {
        defaultFallbackConstructor =
            '${ctor.redirectedConstructor!.beginToken.lexeme}$_classTypeParametersSource';
        // this will be included on the default branch
        continue;
      }

      _codeWriter
        ..writeln('case ${jsonKeyValue ?? "'${ctor.name!.lexeme}'"}:')
        ..writeln(
            'return ${ctor.redirectedConstructor!.beginToken.lexeme}$_classTypeParametersSource.fromJson(json);');
    }

    if (unionFallbackJsonValue != null && defaultFallbackConstructor == null) {
      print(
          'WARNING: "unionFallbackJsonValue: $unionFallbackJsonValue" is not declared as UnionJsonKeyValue');
    }

    _codeWriter.writeln('default:');

    if (defaultFallbackConstructor == null) {
      _codeWriter.writeln("throw UnimplementedError('No JSON key value matched');");
    } else {
      _codeWriter.writeln('return $defaultFallbackConstructor.fromJson(json);');
    }

    _codeWriter.writeln('}}');
  }
}
