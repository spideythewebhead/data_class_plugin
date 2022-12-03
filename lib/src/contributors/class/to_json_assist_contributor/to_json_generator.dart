import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';

class ToJsonGenerator {
  ToJsonGenerator({
    this.checkIfShouldUseToJson,
  });

  final bool Function(DartType dartType)? checkIfShouldUseToJson;

  void run({
    required final DartType? nextType,
    required final DartEditBuilder builder,
    required final int depthIndex,
    required final String parentVariableName,
  }) {
    if (nextType == null) {
      return;
    }

    if (nextType.isDartCoreList) {
      _writeList(
        builder: builder,
        type: nextType as ParameterizedType,
        parentVariableName: parentVariableName,
        depthIndex: depthIndex,
        requiresBangOperator: depthIndex == 0,
      );
      builder.writeln(',');
      return;
    }

    if (nextType.isDartCoreMap) {
      _writeMap(
        builder: builder,
        type: nextType as ParameterizedType,
        parentVariableName: parentVariableName,
        depthIndex: depthIndex,
        requiresBangOperator: depthIndex == 0,
      );
      builder.writeln(',');
      return;
    }

    _writePrimary(
      builder: builder,
      type: nextType,
      parentVariableName: parentVariableName,
    );
  }

  String _getBangOperatorIfNullable(DartType type) {
    return type.isNullable ? '!' : '';
  }

  void _writeNullableParsingPrefix({
    required final DartEditBuilder builder,
    required final String parentVariableName,
  }) {
    builder.write('$parentVariableName == null ? null : ');
  }

  void _writePrimary({
    required final DartEditBuilder builder,
    required final DartType type,
    required final String parentVariableName,
  }) {
    if (type.isDynamic || type.isPrimary) {
      builder.writeln('$parentVariableName,');
      return;
    }

    final String? fieldType = type.element!.name;

    if (type.element is ClassElement || type.element is EnumElement) {
      final InterfaceElement element = type.element as InterfaceElement;
      final String? convertMethod = <String>[
        ...element.methods.map((MethodElement method) => method.name),
        ...element.constructors.map((ConstructorElement ctor) => ctor.name)
      ].firstWhereOrNull((String name) {
        switch (name) {
          case 'toMap':
          case 'toJson':
            return true;
          default:
            return false;
        }
      });

      if (convertMethod != null) {
        builder.writeln('$parentVariableName.$convertMethod(),');
        return;
      }

      if (checkIfShouldUseToJson?.call(type) ?? false) {
        builder.writeln('$parentVariableName.toJson(),');
        return;
      }
    }

    builder.write('jsonConverterRegistrant.find($fieldType).toJson($parentVariableName),');
  }

  void _writeList({
    required final DartEditBuilder builder,
    required final ParameterizedType type,
    required final String parentVariableName,
    required final int depthIndex,
    required final bool requiresBangOperator,
  }) {
    if (type.isNullable) {
      _writeNullableParsingPrefix(
        builder: builder,
        parentVariableName: parentVariableName,
      );
    }

    builder.write('<dynamic>[');

    final String loopVariableName = 'i$depthIndex';
    builder.writeln('for (final '
        '${type.typeArguments[0].typeStringValue()} '
        '$loopVariableName in $parentVariableName'
        '${requiresBangOperator ? _getBangOperatorIfNullable(type) : ''})');

    run(
      nextType: type.typeArguments.first,
      builder: builder,
      parentVariableName: loopVariableName,
      depthIndex: 1 + depthIndex,
    );

    builder.writeln(']');
  }

  void _writeMap({
    required final DartEditBuilder builder,
    required final ParameterizedType type,
    required final String parentVariableName,
    required final int depthIndex,
    required final bool requiresBangOperator,
  }) {
    if (!type.typeArguments[0].isDartCoreString) {
      return;
    }

    if (type.isNullable) {
      _writeNullableParsingPrefix(
        builder: builder,
        parentVariableName: parentVariableName,
      );
    }

    builder.write('<String, dynamic>{');

    final String loopVariableName = 'e$depthIndex';
    builder
      ..writeln('for (final '
          'MapEntry<String, ${type.typeArguments[1].typeStringValue()}> '
          '$loopVariableName in $parentVariableName'
          '${requiresBangOperator ? _getBangOperatorIfNullable(type) : ''}'
          '.entries)')
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
