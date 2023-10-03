import 'dart:async';

import 'package:data_class_plugin/src/common/generator.dart';
import 'package:data_class_plugin/src/extensions/annotation_extensions.dart';
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';
import 'package:path/path.dart';
import 'package:tachyon/tachyon.dart';

const String _kVmPreferInline = "@pragma('vm:prefer-inline')";
const String _kOverride = '@override';

class CopyWithGenerator implements Generator {
  CopyWithGenerator({
    required final CodeWriter codeWriter,
    required final List<DeclarationInfo> fields,
    required final String className,
    required final String generatedClassName,
    required final String classTypeParametersSource,
    required final String classTypeParametersWithoutConstraints,
    required final ClassOrEnumDeclarationFinder classDeclarationFinder,
    required final String projectDirectoryPath,
    required final DataClassPluginOptions pluginOptions,
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

  Future<void> _writeCopyWithProxyClass() async {
    _codeWriter
      ..writeln()
      ..writeln('abstract interface class _${_className}CopyWithProxy$_classTypeParametersSource {')
      ..writeln();

    for (final DeclarationInfo field in _fields) {
      final TachyonDartType dartType = field.type.customDartType;
      final String fieldName = field.name;

      bool useCopyWithProxy = false;
      if (!dartType.isPrimitive &&
          !dartType.isList &&
          !dartType.isUri &&
          !dartType.isDateTime &&
          !dartType.isDuration) {
        final ClassOrEnumDeclarationMatch? match = await _classDeclarationFinder(dartType.name);

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
          ..write(
              '\$${dartType.name}CopyWithProxyChain<$_className$_classTypeParametersWithoutConstraints>')
          ..write(dartType.isNullable ? '?' : '')
          ..writeln(' get $fieldName;')
          ..writeln();
        continue;
      }

      _codeWriter
        ..writeln()
        ..writeln(
            '$_className$_classTypeParametersWithoutConstraints $fieldName(${dartType.fullTypeName} newValue);')
        ..writeln();
    }

    _codeWriter
      ..writeln()
      ..writeln('$_className$_classTypeParametersWithoutConstraints call(');

    if (_fields.isNotEmpty) {
      _codeWriter.write('{');
      for (final DeclarationInfo field in _fields) {
        final TachyonDartType dartType = field.type.customDartType;
        _codeWriter.write(
            'final ${dartType.fullTypeName}${dartType.isNullable ? '' : '?'} ${field.name},');
      }
      _codeWriter.write('}');
    }

    _codeWriter
      ..writeln(');')
      ..writeln('}');
  }

  Future<void> _writeCopyWithProxyImplClass() async {
    _codeWriter
      ..writeln()
      ..writeln(
          'class _${_className}CopyWithProxyImpl$_classTypeParametersSource implements _${_className}CopyWithProxy$_classTypeParametersWithoutConstraints {');

    _codeWriter
      ..writeln('_${_className}CopyWithProxyImpl(this._value);')
      ..writeln()
      ..writeln('final $_className$_classTypeParametersWithoutConstraints _value;')
      ..writeln();

    for (final DeclarationInfo field in _fields) {
      final TachyonDartType dartType = field.type.customDartType;
      final String fieldName = field.name;

      bool useCopyWithProxy = false;
      if (!dartType.isPrimitive &&
          !dartType.isList &&
          !dartType.isUri &&
          !dartType.isDateTime &&
          !dartType.isDuration) {
        final ClassOrEnumDeclarationMatch? match = await _classDeclarationFinder(dartType.name);

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
          ..writeln(_kOverride)
          ..write(
              '\$${dartType.name}CopyWithProxyChain<$_className$_classTypeParametersWithoutConstraints>')
          ..write(dartType.isNullable ? '?' : '')
          ..write(' get $fieldName => ')
          ..write(dartType.isNullable ? '_value.$fieldName == null ? null : ' : '')
          ..writeln(
              '\$${dartType.name}CopyWithProxyChain<$_className$_classTypeParametersWithoutConstraints>(_value.$fieldName')
          ..write(dartType.isNullable ? '!' : '')
          ..writeln(', (${dartType.fullTypeName} update) => this($fieldName: update));')
          ..writeln();
        continue;
      }

      _codeWriter
        ..writeln()
        ..writeln(_kVmPreferInline)
        ..writeln(_kOverride)
        ..writeln(
            '$_className$_classTypeParametersWithoutConstraints $fieldName(${dartType.fullTypeName} newValue) => ')
        ..writeln('this($fieldName: newValue);')
        ..writeln();
    }

    _codeWriter
      ..writeln()
      ..writeln(_kVmPreferInline)
      ..writeln(_kOverride)
      ..writeln('$_className$_classTypeParametersWithoutConstraints call(');

    if (_fields.isNotEmpty) {
      _codeWriter.write('{');
      for (final DeclarationInfo field in _fields) {
        final TachyonDartType dartType = field.type.customDartType;

        if (dartType.isNullable) {
          _codeWriter.write('final Object? ${field.name} = const Object(),');
        } else {
          _codeWriter.write('final ${dartType.fullTypeName}? ${field.name},');
        }
      }
      _codeWriter.write('}');
    }

    _codeWriter
      ..writeln(') {')
      ..writeln('return $_generatedClassName$_classTypeParametersWithoutConstraints(');

    for (final DeclarationInfo field in _fields) {
      final TachyonDartType dartType = field.type.customDartType;
      final String fieldName = field.name;

      if (field.isNamed) {
        _codeWriter.write('$fieldName: ');
      }

      if (dartType.isNullable) {
        _codeWriter
          ..write('identical($fieldName, const Object())')
          ..write(' ? _value.$fieldName : ($fieldName as ${dartType.fullTypeName}),');
      } else {
        _codeWriter.writeln('$fieldName ?? _value.$fieldName,');
      }
    }

    _codeWriter
      ..writeln(');')
      ..writeln('}')
      ..writeln('}');
  }

  Future<void> _writeCopyWithProxyChainClass({
    required final String proxyChainGenericArgs,
    required final String proxyChainGenericArgsWithoutConstraints,
  }) async {
    _codeWriter
      ..writeln()
      ..writeln('sealed class \$${_className}CopyWithProxyChain$proxyChainGenericArgs {');

    _codeWriter
      ..writeln(
          'factory \$${_className}CopyWithProxyChain(final $_className$_classTypeParametersWithoutConstraints value, final \$Result Function($_className$_classTypeParametersWithoutConstraints update) chain) = _${_className}CopyWithProxyChainImpl$proxyChainGenericArgsWithoutConstraints;')
      ..writeln();

    for (final DeclarationInfo field in _fields) {
      final TachyonDartType dartType = field.type.customDartType;
      final String fieldName = field.name;

      _codeWriter
        ..writeln()
        ..writeln('\$Result $fieldName(${dartType.fullTypeName} newValue);')
        ..writeln();
    }

    _codeWriter
      ..writeln()
      ..writeln('\$Result call(');

    if (_fields.isNotEmpty) {
      _codeWriter.write('{');
      for (final DeclarationInfo field in _fields) {
        final TachyonDartType dartType = field.type.customDartType;
        _codeWriter.write(
            'final ${dartType.fullTypeName}${dartType.isNullable ? '' : '?'} ${field.name},');
      }
      _codeWriter.write('}');
    }

    _codeWriter
      ..writeln(');')
      ..writeln('}');
  }

  Future<void> _writeCopyWithProxyChainImplClass({
    required final String proxyChainGenericArgs,
    required final String proxyChaingenericArgsWithoutConstraints,
  }) async {
    _codeWriter
      ..writeln()
      ..writeln(
          'class _${_className}CopyWithProxyChainImpl$proxyChainGenericArgs implements \$${_className}CopyWithProxyChain$proxyChaingenericArgsWithoutConstraints {');

    _codeWriter
      ..writeln('_${_className}CopyWithProxyChainImpl(this._value, this._chain);')
      ..writeln()
      ..writeln('final $_className$_classTypeParametersWithoutConstraints _value;')
      ..writeln(
          'final \$Result Function($_className$_classTypeParametersWithoutConstraints update) _chain;')
      ..writeln();

    for (final DeclarationInfo field in _fields) {
      final TachyonDartType dartType = field.type.customDartType;
      final String fieldName = field.name;

      _codeWriter
        ..writeln()
        ..writeln(_kVmPreferInline)
        ..writeln(_kOverride)
        ..writeln('\$Result $fieldName(${dartType.fullTypeName} newValue) => ')
        ..writeln('this($fieldName: newValue);')
        ..writeln();
    }

    _codeWriter
      ..writeln()
      ..writeln(_kVmPreferInline)
      ..writeln(_kOverride)
      ..writeln('\$Result call(');

    if (_fields.isNotEmpty) {
      _codeWriter.write('{');
      for (final DeclarationInfo field in _fields) {
        final TachyonDartType dartType = field.type.customDartType;

        if (dartType.isNullable) {
          _codeWriter.write('final Object? ${field.name} = const Object(),');
        } else {
          _codeWriter.write('final ${dartType.fullTypeName}? ${field.name},');
        }
      }
      _codeWriter.write('}');
    }

    _codeWriter
      ..writeln(') {')
      ..writeln('return _chain($_generatedClassName$_classTypeParametersWithoutConstraints(');

    for (final DeclarationInfo field in _fields) {
      final TachyonDartType dartType = field.type.customDartType;
      final String fieldName = field.name;

      if (field.isNamed) {
        _codeWriter.write('$fieldName: ');
      }

      if (dartType.isNullable) {
        _codeWriter
          ..write('identical($fieldName, const Object())')
          ..writeln(' ? _value.$fieldName : ($fieldName as ${dartType.fullTypeName}),');
      } else {
        _codeWriter.writeln('$fieldName ?? _value.$fieldName,');
      }
    }

    _codeWriter
      ..writeln(')')
      ..writeln(');')
      ..writeln('}')
      ..writeln('}');
  }

  @override
  Future<void> execute() async {
    await _writeCopyWithProxyClass();
    await _writeCopyWithProxyImplClass();

    late final String proxyChainGenericArgs;
    late final String proxyChainGenericArgsWithoutConstraints;
    if (_classTypeParametersSource.isEmpty) {
      proxyChainGenericArgs = proxyChainGenericArgsWithoutConstraints = '<\$Result>';
    } else {
      int lastGreaterThanIndex = _classTypeParametersSource.lastIndexOf('>');
      proxyChainGenericArgs =
          '${_classTypeParametersSource.substring(0, lastGreaterThanIndex)}, \$Result>';

      lastGreaterThanIndex = _classTypeParametersWithoutConstraints.lastIndexOf('>');
      proxyChainGenericArgsWithoutConstraints =
          '${_classTypeParametersWithoutConstraints.substring(0, lastGreaterThanIndex)}, \$Result>';
    }

    await _writeCopyWithProxyChainClass(
      proxyChainGenericArgs: proxyChainGenericArgs,
      proxyChainGenericArgsWithoutConstraints: proxyChainGenericArgsWithoutConstraints,
    );
    await _writeCopyWithProxyChainImplClass(
      proxyChainGenericArgs: proxyChainGenericArgs,
      proxyChaingenericArgsWithoutConstraints: proxyChainGenericArgsWithoutConstraints,
    );
  }
}
