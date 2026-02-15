import 'dart:core';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:data_class_plugin/src/annotations/constants.dart';
import 'package:data_class_plugin/src/extensions/core_extensions.dart';

extension DartTypeX on DartType {
  bool get isNullable {
    return nullabilitySuffix != NullabilitySuffix.none;
  }

  bool get isPrimary {
    return isDartCoreString ||
        isDartCoreBool ||
        isDartCoreDouble ||
        isDartCoreInt ||
        isDartCoreNum ||
        isDartCoreNull;
  }

  bool get isDateTime {
    return element?.name == 'DateTime';
  }

  bool get isUri {
    return element?.name == 'Uri';
  }

  bool get isJsonSupported {
    return isPrimary ||
        isDateTime ||
        isDartCoreMap ||
        isDartCoreList ||
        isDartCoreEnum ||
        !isDartCoreFunction ||
        alias == null;
  }

  String typeStringValue({required List<LibraryImport> enclosingImports}) {
    final StringBuffer buffer = StringBuffer();

    void visit(DartType type) {
      if (type is InterfaceType && type.typeArguments.isNotEmpty) {
        buffer
          ..write(type.element.name)
          ..write('<');

        for (int i = 0; i < type.typeArguments.length; i += 1) {
          final DartType typeArg = type.typeArguments[i];
          visit(typeArg);
          if (1 + i != type.typeArguments.length) {
            buffer.write(', ');
          }
        }

        buffer.write('>');

        if (type.isNullable) {
          buffer.write('?');
        }
        return;
      }

      String qualifiedName = type.element!.name!;

      // adds any potential prefixes on the class name
      // e.g
      // import 'user.dart' as u;
      // List<u.User>
      for (final LibraryImport import in enclosingImports) {
        if (import.prefix != null && import.importedLibrary?.id == type.element?.library?.id) {
          qualifiedName = '${import.prefix!.element.name}.$qualifiedName';
          break;
        }
      }

      buffer.write(qualifiedName);
      if (type.isNullable) {
        buffer.write('?');
      }
    }

    visit(this);
    return buffer.toString();
  }
}

extension ExecutableElementX<T> on ExecutableElement {
  String fullyQualifiedName({required List<LibraryImport> enclosingImports}) {
    String qualifiedName = name!;

    if ((enclosingElement?.name?.length ?? 0) > 0) {
      qualifiedName = '${enclosingElement!.name}.$qualifiedName';
    }

    for (final LibraryImport import in enclosingImports) {
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

  SourceRange? get defaultConstructorSourceRange => getSourceRangeForConstructor(null);
  SourceRange? get privateConstructorSourceRange => getSourceRangeForConstructor('_');

  SourceRange? get fromJsonSourceRange =>
      getSourceRangeForConstructor(DataClassAnnotationArg.fromJson.name);
  SourceRange? get toJsonSourceRange => getSourceRangeForMethod(DataClassAnnotationArg.toJson.name);

  SourceRange? get equalsSourceRange => getSourceRangeForMethod(DataClassAnnotationArg.equals.name);
  SourceRange? get hashSourceRange => getSourceRangeForMethod(DataClassAnnotationArg.hash.name);
  SourceRange? get copyWithSourceRange =>
      getSourceRangeForMethod(DataClassAnnotationArg.copyWith.name);
  SourceRange? get toStringSourceRange =>
      getSourceRangeForMethod(DataClassAnnotationArg.$toString.name);
}

extension InterfaceElementX on InterfaceElement {
  ConstructorElement? get defaultConstructor {
    return constructors.firstWhereOrNull(
      (ConstructorElement ctor) => ctor.name == 'new',
    );
  }

  List<FieldElement> get dataClassFinalFields {
    return <FieldElement>[
      for (final FieldElement field in fields)
        if (field.isFinal && field.isPublic && !field.hasInitializer) field,
    ];
  }

  List<FieldElement> get chainSuperClassDataClassFinalFields {
    final List<FieldElement> fields = <FieldElement>[];

    if (supertype?.element is! ClassElement) {
      return fields;
    }

    ClassElement? superClassClassElement = supertype!.element as ClassElement;
    while (superClassClassElement != null) {
      fields.addAll(superClassClassElement.dataClassFinalFields);
      if (superClassClassElement.supertype?.element case ClassElement? classElement) {
        superClassClassElement = classElement;
      } else {
        superClassClassElement = null;
      }
    }

    return fields;
  }

  List<FieldElement> get jsonSupportedFields {
    return <FieldElement>[
      for (final FieldElement field in fields)
        if (field.isFinal && field.isPublic && field.type.isJsonSupported) field,
    ];
  }
}

extension ConstructorElement2X on ConstructorElement {
  List<FormalParameterElement> get dataClassSuperFields {
    return <FormalParameterElement>[
      for (final FormalParameterElement param in formalParameters)
        if (param.isNamed && param.isSuperFormal) param,
    ];
  }
}

extension InterfaceTypeX on InterfaceType {
  bool hasMethod(String methodName) {
    return null !=
        methods.firstWhereOrNull(
          (MethodElement member) => member.name == methodName,
        );
  }
}

extension ConstructorDeclarationX on ConstructorDeclaration {
  bool get hasParameters => parameters.parameters.isNotEmpty;
}
