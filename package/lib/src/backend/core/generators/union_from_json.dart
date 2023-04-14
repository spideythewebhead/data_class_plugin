import 'package:data_class_plugin/src/annotations/constants.dart';
import 'package:data_class_plugin/src/common/generator.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:tachyon/tachyon.dart';

class UnionFromJsonGenerator implements Generator {
  UnionFromJsonGenerator({
    required final CodeWriter codeWriter,
    required final String className,
    required final String classTypeParametersSource,
    required final String classTypeParametersWithoutConstraints,
    required final List<ConstructorDeclaration> factoriesWithRedirectedConstructors,
    required final AnnotationValueExtractor unionAnnotationValueExtractor,
  })  : _codeWriter = codeWriter,
        _className = className,
        _classTypeParametersSource = classTypeParametersSource,
        _classTypeParametersWithoutConstraints = classTypeParametersWithoutConstraints,
        _factoriesWithRedirectedConstructors = factoriesWithRedirectedConstructors,
        _unionAnnotationValueExtractor = unionAnnotationValueExtractor;

  final CodeWriter _codeWriter;
  final String _className;
  final String _classTypeParametersSource;
  final String _classTypeParametersWithoutConstraints;
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
          '$_className$_classTypeParametersWithoutConstraints _\$${_className}FromJson$_classTypeParametersSource(Map<dynamic, dynamic> json) {')
      ..writeln("switch (json['$unionJsonKey']) {");

    for (final ConstructorDeclaration ctor in _factoriesWithRedirectedConstructors) {
      if (ctor.name!.lexeme == unionFallbackJsonValue) {
        defaultFallbackConstructor =
            '${ctor.redirectedConstructor!.beginToken.lexeme}$_classTypeParametersWithoutConstraints';
        // this will be included on the default branch
        continue;
      }

      final List<Annotation> unionJsonKeyValueAnnotations =
          ctor.metadata.getAllAnnotationsByType(AnnotationType.unionJsonKeyValue);
      for (final Annotation annotation in unionJsonKeyValueAnnotations) {
        final String? jsonKeyValue =
            AnnotationValueExtractor(annotation).getPositionedArgument(0)?.toSource();
        if (jsonKeyValue == null) {
          continue;
        }
        _codeWriter.writeln('case $jsonKeyValue:');
      }

      if (unionJsonKeyValueAnnotations.isEmpty) {
        _codeWriter.writeln("case '${ctor.name}':");
      }

      _codeWriter.writeln(
          'return ${ctor.redirectedConstructor!.beginToken.lexeme}$_classTypeParametersWithoutConstraints.fromJson(json);');
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
