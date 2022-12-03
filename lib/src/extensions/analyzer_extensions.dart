import 'dart:core';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:data_class_plugin/src/extensions/core_extensions.dart';

extension ExecutableElementX<T> on ExecutableElement {
  String fullyQualifiedName({
    required List<LibraryImportElement> enclosingImports,
  }) {
    String qualifiedName = name;

    if (enclosingElement.nameLength > 0) {
      qualifiedName = '${enclosingElement.name!}.$qualifiedName';
    }

    for (final LibraryImportElement import in enclosingImports) {
      if (import.prefix != null && import.importedLibrary?.id == library.id) {
        qualifiedName = '${import.prefix!.element.name}.$qualifiedName';
        break;
      }
    }

    return qualifiedName;
  }
}

extension NodeListX on NodeList<ClassMember> {
  SourceRange? getSourceRangeForConstructor(String? name) {
    for (final ClassMember node in this) {
      if (node is ConstructorDeclaration && node.name?.lexeme == name) {
        return SourceRange(node.offset, node.length);
      }
    }
    return null;
  }

  SourceRange? getSourceRangeForMethod(String name) {
    for (final ClassMember node in this) {
      if (node is MethodDeclaration && node.name.lexeme == name) {
        return SourceRange(node.offset, node.length);
      }
    }
    return null;
  }
}

extension InterfaceElementX on InterfaceElement {
  ConstructorElement? get defaultConstructor {
    return constructors.firstWhereOrNull((ConstructorElement ctor) => ctor.name.isEmpty);
  }

  List<FieldElement> get dataClassFinalFields {
    return <FieldElement>[
      for (final FieldElement field in fields)
        if (field.isFinal && field.isPublic && !field.hasInitializer) field,
    ];
  }

  List<FieldElement> get chainSuperClassDataClassFinalFields {
    final List<FieldElement> fields = <FieldElement>[];

    ClassElement? superClassClassElement = supertype?.classElement;
    while (superClassClassElement != null) {
      fields.addAll(superClassClassElement.dataClassFinalFields);
      superClassClassElement = superClassClassElement.supertype?.classElement;
    }

    return fields;
  }
}

extension ConstructorElementX on ConstructorElement {
  List<ParameterElement> get dataClassSuperFields {
    return <ParameterElement>[
      for (final ParameterElement param in parameters)
        if (param.isNamed && param.isSuperFormal) param
    ];
  }
}

extension InterfaceTypeX on InterfaceType {
  ClassElement? get classElement {
    return element is ClassElement ? element as ClassElement : null;
  }
}
