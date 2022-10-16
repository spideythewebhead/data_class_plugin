import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:data_class_plugin/src/annotations/map_key.dart';

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
    return element2!.name == 'DateTime';
  }

  bool get isUri {
    return element2!.name == 'Uri';
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

  String typeStringValue() {
    final StringBuffer buffer = StringBuffer();

    void visit(DartType type) {
      if (type is InterfaceType && type.typeArguments.isNotEmpty) {
        buffer
          ..write(type.element2.name)
          ..write('<');

        for (final DartType typeArg in type.typeArguments) {
          visit(typeArg);
          if (typeArg != type.typeArguments.last) {
            buffer.write(',');
          }
        }

        buffer.write('>');
        return;
      }

      buffer.write(type.element2!.name);
    }

    visit(this);
    return buffer.toString();
  }
}

extension ElementAnnotationX on ElementAnnotation {
  bool get isMapKeyAnnotation {
    return element?.displayName == '$MapKey';
  }
}

extension ListX<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    try {
      return firstWhere(test);
    } catch (_) {
      return null;
    }
  }
}

extension ExecutableElementX<T> on ExecutableElement {
  String fullyQualifiedName({
    required List<LibraryImportElement> enclosingImports,
  }) {
    String qualifiedName = name;

    if (enclosingElement3.nameLength > 0) {
      qualifiedName = '${enclosingElement3.name!}.$qualifiedName';
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
  SourceRange? getSourceRangeForFactory(String name) {
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
