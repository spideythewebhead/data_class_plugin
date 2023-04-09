import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:data_class_plugin/src/backend/core/custom_dart_object.dart';
import 'package:data_class_plugin/src/backend/core/custom_dart_type.dart';
import 'package:data_class_plugin/src/backend/core/declaration_finder.dart';
import 'package:data_class_plugin/src/backend/core/declaration_info.dart';
import 'package:data_class_plugin/src/backend/core/generators/generator.dart';
import 'package:data_class_plugin/src/backend/core/typedefs.dart';
import 'package:data_class_plugin/src/common/code_writer.dart';
import 'package:data_class_plugin/src/extensions/annotation_extensions.dart';
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';
import 'package:path/path.dart';

const String _kVmPreferInline = "@pragma('vm:prefer-inline')";

class CopyWithGenerator implements Generator {
  CopyWithGenerator({
    required final CodeWriter codeWriter,
    required final List<DeclarationInfo> fields,
    required final String className,
    required final String generatedClassName,
    required final String classTypeParametersSource,
    required final String classTypeParametersWithoutConstraints,
    required ClassOrEnumDeclarationFinder classDeclarationFinder,
    required String projectDirectoryPath,
    required DataClassPluginOptions pluginOptions,
  })  : _codeWriter = codeWriter,
        _className = className,
        _generatedClassName = generatedClassName,
        _classTypeParametersSource = classTypeParametersSource,
        _classTypeParametersWithoutConstraints = classTypeParametersWithoutConstraints,
        _fields = fields,
        _classDeclarationFinder = classDeclarationFinder,
        _projectDirectoryPath = projectDirectoryPath,
        _pluginOptions = pluginOptions;

  final CodeWriter _codeWriter;
  final String _className;
  final String _generatedClassName;
  final String _classTypeParametersSource;
  final String _classTypeParametersWithoutConstraints;
  final List<DeclarationInfo> _fields;
  final ClassOrEnumDeclarationFinder _classDeclarationFinder;
  final String _projectDirectoryPath;
  final DataClassPluginOptions _pluginOptions;

  @override
  Future<void> execute() async {
    _codeWriter
      ..writeln()
      ..writeln('class _\$${_className}CopyWithProxy$_classTypeParametersSource {');

    _codeWriter
      ..writeln('_\$${_className}CopyWithProxy(this._value);')
      ..writeln()
      ..writeln('final $_className$_classTypeParametersWithoutConstraints _value;')
      ..writeln();

    for (final DeclarationInfo field in _fields) {
      final CustomDartType customDartType = field.type.customDartType;
      final String fieldName = field.name;

      bool useCopyWithProxy = false;
      if (!customDartType.isPrimary &&
          !customDartType.isList &&
          !customDartType.isUri &&
          !customDartType.isDateTime &&
          !customDartType.isDuration) {
        final ClassOrEnumDeclarationMatch? match =
            await _classDeclarationFinder(customDartType.name);

        final NamedCompilationUnitMember? node = match?.node;
        if (match != null && node is ClassDeclaration && node.hasDataClassAnnotation) {
          final String relativeFilePath = relative(match.filePath, from: _projectDirectoryPath);
          useCopyWithProxy =
              AnnotationValueExtractor(node.dataClassAnnotation).getBool('copyWith') ??
                  (_pluginOptions.dataClass.effectiveCopyWith(relativeFilePath));
        }
      }

      if (useCopyWithProxy) {
        _codeWriter
          ..writeln(_kVmPreferInline)
          ..write(
              '\$${customDartType.name}CopyWithProxyChain<$_className$_classTypeParametersWithoutConstraints>')
          ..write(customDartType.isNullable ? '?' : '')
          ..write(' get $fieldName => ')
          ..write(customDartType.isNullable ? '_value.$fieldName == null ? null : ' : '')
          ..writeln(
              '\$${customDartType.name}CopyWithProxyChain<$_className$_classTypeParametersWithoutConstraints>(_value.$fieldName')
          ..write(customDartType.isNullable ? '!' : '')
          ..writeln(', (${customDartType.fullTypeName} update) => this($fieldName: update));')
          ..writeln();
        continue;
      }

      _codeWriter
        ..writeln()
        ..writeln(_kVmPreferInline)
        ..writeln(
            '$_className$_classTypeParametersWithoutConstraints $fieldName(${customDartType.fullTypeName} newValue) => ')
        ..writeln('this($fieldName: newValue);');
    }

    _codeWriter
      ..writeln()
      ..writeln(_kVmPreferInline)
      ..writeln('$_className$_classTypeParametersWithoutConstraints call(');

    if (_fields.isNotEmpty) {
      _codeWriter.write('{');
      for (final DeclarationInfo field in _fields) {
        final CustomDartType customDartType = field.type.customDartType;

        if (customDartType.isNullable) {
          _codeWriter.write('final Object? ${field.name} = const Object(),');
        } else {
          _codeWriter.write('final ${customDartType.fullTypeName}? ${field.name},');
        }
      }
      _codeWriter.write('}');
    }

    _codeWriter
      ..writeln(') {')
      ..writeln('return $_generatedClassName$_classTypeParametersWithoutConstraints(');

    for (final DeclarationInfo field in _fields) {
      final CustomDartType customDartType = field.type.customDartType;
      final String fieldName = field.name;

      if (customDartType.isNullable) {
        _codeWriter
          ..write('$fieldName: identical($fieldName, const Object())')
          ..write(' ? _value.$fieldName : ($fieldName as ${customDartType.fullTypeName}),');
      } else {
        _codeWriter.writeln('$fieldName: $fieldName ?? _value.$fieldName,');
      }
    }

    _codeWriter
      ..writeln(');')
      ..writeln('}') // call()
      ..writeln('}'); // proxy class

    String proxyChainGenericArgs = '';
    if (_classTypeParametersSource.isEmpty) {
      proxyChainGenericArgs = '<\$Result>';
    } else {
      final int lastGreaterThanIndex = _classTypeParametersSource.lastIndexOf('>');
      proxyChainGenericArgs =
          '${_classTypeParametersSource.substring(0, lastGreaterThanIndex)}, \$Result>';
    }
    _codeWriter
      ..writeln()
      ..writeln('class \$${_className}CopyWithProxyChain$proxyChainGenericArgs {');

    _codeWriter
      ..writeln('\$${_className}CopyWithProxyChain(this._value, this._chain);')
      ..writeln()
      ..writeln('final $_className$_classTypeParametersWithoutConstraints _value;')
      ..writeln(
          'final \$Result Function($_className$_classTypeParametersWithoutConstraints update) _chain;')
      ..writeln();

    for (final DeclarationInfo field in _fields) {
      final CustomDartType customDartType = field.type.customDartType;
      final String fieldName = field.name;

      _codeWriter
        ..writeln()
        ..writeln(_kVmPreferInline)
        ..writeln('\$Result $fieldName(${customDartType.fullTypeName} newValue) => ')
        ..writeln('this($fieldName: newValue);')
        ..writeln();
    }

    _codeWriter
      ..writeln()
      ..writeln(_kVmPreferInline)
      ..writeln('\$Result call(');

    if (_fields.isNotEmpty) {
      _codeWriter.write('{');
      for (final DeclarationInfo field in _fields) {
        final CustomDartType customDartType = field.type.customDartType;

        if (customDartType.isNullable) {
          _codeWriter.write('final Object? ${field.name} = const Object(),');
        } else {
          _codeWriter.write('final ${customDartType.fullTypeName}? ${field.name},');
        }
      }
      _codeWriter.write('}');
    }

    _codeWriter
      ..writeln(') {')
      ..writeln('return _chain($_generatedClassName$_classTypeParametersWithoutConstraints(');

    for (final DeclarationInfo field in _fields) {
      final CustomDartType customDartType = field.type.customDartType;
      final String fieldName = field.name;

      if (customDartType.isNullable) {
        _codeWriter
          ..write('$fieldName: identical($fieldName, const Object())')
          ..write(' ? _value.$fieldName : ($fieldName as ${customDartType.fullTypeName}),');
      } else {
        _codeWriter.writeln('$fieldName: $fieldName ?? _value.$fieldName,');
      }
    }

    _codeWriter
      ..writeln('));') //
      ..writeln('}') // call()
      ..writeln('}'); // proxy class
  }
}
