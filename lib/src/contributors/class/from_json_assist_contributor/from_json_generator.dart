import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/extensions.dart';

class FromJsonGenerator {
  /// Shorthand constructor
  FromJsonGenerator({
    this.checkIfShouldUseFromJson,
  });

  final bool Function(DartType dartType)? checkIfShouldUseFromJson;

  void run({
    required final DartType? nextType,
    required final DartEditBuilder builder,
    required final int depthIndex,
    required final String parentVariableName,
    final String? defaultValue,
  }) {
    if (nextType == null) {
      return;
    }

    if (nextType.isDartCoreList) {
      if (nextType.isNullable || defaultValue != null) {
        _writeNullableParsingPrefix(
          builder: builder,
          parentVariableName: parentVariableName,
          defaultValue: defaultValue,
        );
      }
      _parseList(
        builder: builder,
        type: nextType as ParameterizedType,
        parentVariableName: parentVariableName,
        depthIndex: depthIndex,
      );
      builder.writeln(',');
      return;
    }

    if (nextType.isDartCoreMap) {
      if (nextType.isNullable || defaultValue != null) {
        _writeNullableParsingPrefix(
          builder: builder,
          parentVariableName: parentVariableName,
          defaultValue: defaultValue,
        );
      }
      _parseMap(
        builder: builder,
        type: nextType as ParameterizedType,
        parentVariableName: parentVariableName,
        depthIndex: depthIndex,
      );
      builder.writeln(',');
      return;
    }

    if (nextType.isNullable || defaultValue != null) {
      _writeNullableParsingPrefix(
        builder: builder,
        parentVariableName: parentVariableName,
        defaultValue: defaultValue,
      );
    }

    _parsePrimary(
      builder: builder,
      type: nextType,
      parentVariableName: parentVariableName,
    );
  }

  void _writeNullableParsingPrefix({
    required final DartEditBuilder builder,
    required final String parentVariableName,
    final String? defaultValue,
  }) {
    builder.write('$parentVariableName == null ? $defaultValue : ');
  }

  void _parsePrimary({
    required final DartEditBuilder builder,
    required final DartType type,
    required final String parentVariableName,
  }) {
    final String? fieldType = type.element!.name;

    if (type.isDynamic) {
      builder
        ..writeln('// FIXME: variable is dynamic or contains a type that is not yet declared')
        ..writeln('$parentVariableName, ');
      return;
    }

    if (type.isPrimary) {
      builder.writeln('$parentVariableName as $fieldType,');
      return;
    }

    if (type.element is ClassElement || type.element is EnumElement) {
      final InterfaceElement element = type.element as InterfaceElement;
      final String? convertMethod = <String>[
        ...element.methods.map((MethodElement method) => method.name),
        ...element.constructors.map((ConstructorElement ctor) => ctor.name)
      ].firstWhereOrNull((String name) {
        switch (name) {
          case 'fromMap':
          case 'fromJson':
            return true;
          default:
            return false;
        }
      });

      if (convertMethod != null) {
        builder.writeln('$fieldType.$convertMethod($parentVariableName),');
        return;
      }

      if (checkIfShouldUseFromJson?.call(type) ?? false) {
        builder.writeln('$fieldType.fromJson($parentVariableName),');
        return;
      }
    }

    builder.write('jsonConverterRegistrant.find($fieldType).fromJson($parentVariableName) '
        'as $fieldType,');
  }

  void _parseList({
    required final DartEditBuilder builder,
    required final ParameterizedType type,
    required final String parentVariableName,
    required final int depthIndex,
  }) {
    builder.write('<${type.typeArguments[0].typeStringValue()}>[');

    final String loopVariableName = 'i$depthIndex';
    builder.writeln(
        'for (final dynamic $loopVariableName in ($parentVariableName as ${type.element!.name}<dynamic>))');

    run(
      nextType: type.typeArguments[0],
      builder: builder,
      parentVariableName: loopVariableName,
      depthIndex: 1 + depthIndex,
    );

    builder.writeln(']');
  }

  void _parseMap({
    required final DartEditBuilder builder,
    required final ParameterizedType type,
    required final String parentVariableName,
    required final int depthIndex,
  }) {
    if (!type.typeArguments[0].isDartCoreString) {
      return;
    }

    builder.write('<String, ${type.typeArguments[1].typeStringValue()}>{');

    final String loopVariableName = 'e$depthIndex';
    builder
      ..writeln(
          'for (final MapEntry<String, dynamic> $loopVariableName in ($parentVariableName as ${type.element!.name}<String, dynamic>).entries)')
      ..write('$loopVariableName.key: ');

    run(
      nextType: type.typeArguments[1],
      builder: builder,
      parentVariableName: '$loopVariableName.value',
      depthIndex: 1 + depthIndex,
    );

    builder.writeln('}');
  }
}
