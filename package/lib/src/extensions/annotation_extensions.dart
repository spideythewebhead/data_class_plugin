import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart' as protocol;
import 'package:data_class_plugin/src/annotations/constants.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';

extension ElementX on Element {
  bool get hasDataClassAnnotation => dataClassAnnotation != null;
  ElementAnnotation? get dataClassAnnotation => metadata.getAnnotation(AnnotationType.dataClass);

  bool get hasUnionAnnotation => unionAnnotation != null;
  ElementAnnotation? get unionAnnotation => metadata.getAnnotation(AnnotationType.union);

  bool get hasEnumAnnotation => enumAnnotation != null;
  ElementAnnotation? get enumAnnotation => metadata.getAnnotation(AnnotationType.enumeration);

  bool get hasDefaultValueAnnotation => defaultValueAnnotation != null;
  ElementAnnotation? get defaultValueAnnotation =>
      metadata.getAnnotation(AnnotationType.defaultValue);

  bool get hasJsonKeyAnnotation => jsonKeyAnnotation != null;
  ElementAnnotation? get jsonKeyAnnotation => metadata.getAnnotation(AnnotationType.jsonKey);
}

extension ClassDeclarationX on ClassDeclaration {
  bool get hasDataClassAnnotation => dataClassAnnotation != null;
  Annotation? get dataClassAnnotation => metadata.getAnnotation(AnnotationType.dataClass);

  bool get hasUnionAnnotation => unionAnnotation != null;
  Annotation? get unionAnnotation => metadata.getAnnotation(AnnotationType.union);

  List<Annotation> get annotations => metadata.annotations;

  bool hasMethod(String methodName) {
    return null !=
        members.firstWhereOrNull((ClassMember member) {
          return member is MethodDeclaration && member.name.lexeme == methodName;
        });
  }
}

extension EnumDeclarationX on EnumDeclaration {
  bool get hasEnumAnnotation => enumAnnotation != null;
  Annotation? get enumAnnotation => metadata.getAnnotation(AnnotationType.enumeration);

  bool hasMethod(String methodName) {
    return null !=
        members.firstWhereOrNull((ClassMember member) {
          return member is MethodDeclaration && member.name.lexeme == methodName;
        });
  }
}

extension ElementAnnotationX on ElementAnnotation {
  bool get isDataClassAnnotation => isPluginAnnotation(AnnotationType.dataClass);
  bool get isEnumAnnotation => isPluginAnnotation(AnnotationType.enumeration);
  bool get isJsonKeyAnnotation => isPluginAnnotation(AnnotationType.jsonKey);
  bool get isUnionAnnotation => isPluginAnnotation(AnnotationType.union);
  bool get isDefaultValueAnnotation => isPluginAnnotation(AnnotationType.defaultValue);

  bool isPluginAnnotation(AnnotationType type) {
    if (element == null) {
      return toSource().startsWith('@${type.name}(');
    } else {
      return element?.displayName == type.name;
    }
  }
}

extension ElementAnnotationListX on List<ElementAnnotation> {
  ElementAnnotation? getAnnotation(AnnotationType annotation) {
    return firstWhereOrNull((ElementAnnotation a) => a.element?.displayName == annotation.name);
  }

  ElementAnnotation? get dataClassAnnotation => getAnnotation(AnnotationType.dataClass);
  ElementAnnotation? get enumAnnotation => getAnnotation(AnnotationType.enumeration);
  ElementAnnotation? get unionAnnotation => getAnnotation(AnnotationType.union);
  ElementAnnotation? get defaultValueAnnotation => getAnnotation(AnnotationType.defaultValue);
}

extension AnnotationNodeListX on NodeList<Annotation> {
  Annotation? getAnnotation(AnnotationType annotation) {
    return firstWhereOrNull((Annotation a) => a.name.name == annotation.name);
  }

  List<Annotation> get annotations {
    return where((Annotation annotation) {
      return AnnotationType.values
              .firstWhereOrNull((AnnotationType element) => annotation.name.name == element.name) !=
          null;
    }).toList(growable: false);
  }

  List<AnnotationType> get pluginAnnotations {
    final List<AnnotationType> annotations = <AnnotationType>[];

    for (final AnnotationType a in AnnotationType.values) {
      if (getAnnotation(a) != null) {
        annotations.add(a);
      }
    }

    return annotations;
  }
}

extension AnnotationX on Annotation {
  SourceRange get sourceRange => SourceRange(beginToken.offset, endToken.end - beginToken.offset);

  /// Returns the [protocol.Location] of the [Annotation]
  protocol.Location getLocation({
    required final String path,
    required final ResolvedUnitResult unit,
  }) {
    final CharacterLocation characterLocation = unit.lineInfo.getLocation(offset);

    return protocol.Location(
      path,
      beginToken.offset,
      endToken.end - beginToken.offset,
      characterLocation.lineNumber,
      characterLocation.columnNumber,
    );
  }

  /// Returns the matched [AnnotationType]
  AnnotationType? get pluginAnnotation {
    for (final AnnotationType a in AnnotationType.values) {
      if (a.name == name.name) {
        return a;
      }
    }

    return null;
  }

  bool get isDataClassAnnotation => isPluginAnnotation(AnnotationType.dataClass);
  bool get isEnumAnnotation => isPluginAnnotation(AnnotationType.enumeration);
  bool get isJsonKeyAnnotation => isPluginAnnotation(AnnotationType.jsonKey);
  bool get isUnionAnnotation => isPluginAnnotation(AnnotationType.union);
  bool get isDefaultValueAnnotation => isPluginAnnotation(AnnotationType.defaultValue);

  bool isPluginAnnotation(AnnotationType type) {
    return name.name == type.name;
  }
}
