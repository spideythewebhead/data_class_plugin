import 'package:data_class_plugin/src/common/generator.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:tachyon/tachyon.dart';

class ConstructorGenerator implements Generator {
  ConstructorGenerator({
    required final CodeWriter codeWriter,
    required final ConstructorDeclaration? constructor,
    required final List<DeclarationInfo> fields,
    required final String generatedClassName,
    final bool shouldAnnotateFieldsWithOverride = true,
    final String? superConstructorName,
    required final bool generateUnmodifiableCollections,
  })  : _codeWriter = codeWriter,
        _constructor = constructor,
        _fields = fields,
        _generatedClassName = generatedClassName,
        _shouldAnnotateFieldsWithOverride = shouldAnnotateFieldsWithOverride,
        _superConstructorName = superConstructorName,
        _generateUnmodifiableCollections = generateUnmodifiableCollections;

  final CodeWriter _codeWriter;
  final ConstructorDeclaration? _constructor;
  final List<DeclarationInfo> _fields;
  final String _generatedClassName;
  final bool _shouldAnnotateFieldsWithOverride;
  final String? _superConstructorName;
  final bool _generateUnmodifiableCollections;

  @override
  void execute() {
    final List<String> unmodifiableCollectionsDeclarations = <String>[];

    _codeWriter.write(_constructor?.constKeyword?.lexeme ?? '');
    _codeWriter.write(' $_generatedClassName(');

    final List<DeclarationInfo> positionalFields =
        _fields.where((DeclarationInfo element) => element.isPositional).toList(growable: false);

    final List<DeclarationInfo> namedFields =
        _fields.where((DeclarationInfo element) => element.isNamed).toList(growable: false);

    for (final DeclarationInfo field in positionalFields) {
      final TachyonDartType dartType = field.type.customDartType;

      if (_generateUnmodifiableCollections && dartType.isCollection) {
        _codeWriter.write('${dartType.fullTypeName} ${field.name},');
        unmodifiableCollectionsDeclarations.add('_${field.name} = ${field.name}');
      } else {
        _codeWriter.write('this.${field.name},');
      }
    }

    if (namedFields.isNotEmpty) {
      _codeWriter.write('{');
      for (final DeclarationInfo field in namedFields) {
        final Annotation? defaultValueAnnotation = field.metadata
            .firstWhereOrNull((Annotation annotation) => annotation.isDefaultValueAnnotation);
        final TachyonDartType dartType = field.type.customDartType;

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
          _codeWriter.write('required ');
        }

        if (_generateUnmodifiableCollections && dartType.isCollection) {
          _codeWriter.write(dartType.fullTypeName);
        } else {
          _codeWriter.write('this.');
        }

        _codeWriter.write(field.name);

        if (defaultValueExpression != null) {
          _codeWriter.write(' = $defaultValuePrefix ${defaultValueExpression.toSource()}');
        }

        if (dartType.isCollection && _generateUnmodifiableCollections) {
          unmodifiableCollectionsDeclarations.add('_${field.name} = ${field.name}');
        }

        _codeWriter.write(',');
      }
      _codeWriter.write('}');
    }

    if (unmodifiableCollectionsDeclarations.isNotEmpty) {
      _codeWriter
        ..write('): ')
        ..write(unmodifiableCollectionsDeclarations.join(', '))
        ..writeln(', super.${_superConstructorName ?? 'ctor'}()')
        ..writeln(';');
    } else {
      _codeWriter.writeln('): super.${_superConstructorName ?? 'ctor'}();');
    }

    _codeWriter.writeln();

    for (final DeclarationInfo field in _fields) {
      final TachyonDartType dartType = field.type.customDartType;

      if (_generateUnmodifiableCollections && dartType.isCollection) {
        _codeWriter
          ..writeln()
          ..writeln(_shouldAnnotateFieldsWithOverride ? '@override' : '')
          ..write('${dartType.fullTypeName} get ${field.name} => ');

        if (dartType.isNullable) {
          final String notNullableType =
              dartType.fullTypeName.substring(0, dartType.fullTypeName.length - 1);
          _codeWriter.write('_${field.name} ?? $notNullableType.unmodifiable(_${field.name}!);');
        } else {
          _codeWriter.writeln('${dartType.fullTypeName}.unmodifiable(_${field.name});');
        }

        _codeWriter
          ..writeln('final ${dartType.fullTypeName} _${field.name};')
          ..writeln();
        continue;
      }

      _codeWriter
        ..writeln(_shouldAnnotateFieldsWithOverride ? '@override' : '')
        ..writeln('final ${dartType.fullTypeName} ${field.name};')
        ..writeln();
    }

    _codeWriter.writeln();
  }
}
