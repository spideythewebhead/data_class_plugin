import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:data_class_plugin/src/extensions/core_extensions.dart';

extension ElementAnnotationX on ElementAnnotation {
  bool get isJsonKeyAnnotation {
    return element?.displayName == 'JsonKey';
  }

  bool get isUnionAnnotation {
    return element?.displayName == 'Union';
  }

  bool get isUnionFieldValueAnnotation {
    return element?.displayName == 'UnionFieldValue';
  }

  bool get isDataClassAnnotation {
    return element?.displayName == 'DataClass';
  }

  bool get isEnumAnnotation {
    return element?.displayName == 'Enum';
  }
}

extension ElementX on Element {
  bool get hasUnionAnnotation {
    return metadata
            .firstWhereOrNull((ElementAnnotation annotation) => annotation.isUnionAnnotation) !=
        null;
  }

  bool get hasDataClassAnnotation {
    return metadata
            .firstWhereOrNull((ElementAnnotation annotation) => annotation.isDataClassAnnotation) !=
        null;
  }

  bool get hasEnumAnnotation {
    return metadata
            .firstWhereOrNull((ElementAnnotation annotation) => annotation.isEnumAnnotation) !=
        null;
  }
}

extension ClassDeclarationX on ClassDeclaration {
  bool get hasDataClassAnnotation {
    return metadata
            .firstWhereOrNull((Annotation annotation) => annotation.name.name == 'DataClass') !=
        null;
  }

  bool get hasUnionAnnotation {
    return metadata.firstWhereOrNull((Annotation annotation) => annotation.name.name == 'Union') !=
        null;
  }
}

extension EnumDeclarationX on EnumDeclaration {
  bool get hasEnumAnnotation {
    return metadata.firstWhereOrNull((Annotation annotation) => annotation.name.name == 'Enum') !=
        null;
  }
}
