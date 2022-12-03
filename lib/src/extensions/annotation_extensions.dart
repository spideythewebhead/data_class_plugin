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
  ElementAnnotation? get dataClassAnnotation => metadata.getAnnotation(AnnotationTypes.dataClass);

  bool get hasUnionAnnotation => unionAnnotation != null;
  ElementAnnotation? get unionAnnotation => metadata.getAnnotation(AnnotationTypes.union);

  bool get hasEnumAnnotation => enumAnnotation != null;
  ElementAnnotation? get enumAnnotation => metadata.getAnnotation(AnnotationTypes.enumeration);
}

extension ClassDeclarationX on ClassDeclaration {
  bool get hasDataClassAnnotation => dataClassAnnotation != null;
  Annotation? get dataClassAnnotation => metadata.getAnnotation(AnnotationTypes.dataClass);

  bool get hasUnionAnnotation => unionAnnotation != null;
  Annotation? get unionAnnotation => metadata.getAnnotation(AnnotationTypes.union);

  List<Annotation> get annotations => metadata.annotations;
}

extension EnumDeclarationX on EnumDeclaration {
  bool get hasEnumAnnotation => enumAnnotation != null;
  Annotation? get enumAnnotation => metadata.getAnnotation(AnnotationTypes.enumeration);
}

extension ElementAnnotationX on ElementAnnotation {
  bool get isDataClassAnnotation => isPluginAnnotation(AnnotationTypes.dataClass);
  bool get isEnumAnnotation => isPluginAnnotation(AnnotationTypes.enumeration);
  bool get isJsonKeyAnnotation => isPluginAnnotation(AnnotationTypes.jsonKey);
  bool get isUnionAnnotation => isPluginAnnotation(AnnotationTypes.union);
  bool get isUnionFieldValueAnnotation => isPluginAnnotation(AnnotationTypes.unionFieldValue);

  bool isPluginAnnotation(AnnotationTypes type) {
    if (element == null) {
      return toSource().startsWith('@${type.name}(');
    } else {
      return element?.displayName == type.name;
    }
  }
}

extension ElementAnnotationListX on List<ElementAnnotation> {
  ElementAnnotation? getAnnotation(AnnotationTypes annotation) {
    return firstWhereOrNull((ElementAnnotation a) => a.element?.displayName == annotation.name);
  }
}

extension AnnotationNodeListX on NodeList<Annotation> {
  Annotation? getAnnotation(AnnotationTypes annotation) {
    return firstWhereOrNull((Annotation a) => a.name.name == annotation.name);
  }

  List<Annotation> get annotations {
    return where((Annotation annotation) {
      return AnnotationTypes.values.firstWhereOrNull(
              (AnnotationTypes element) => annotation.name.name == element.name) !=
          null;
    }).toList(growable: false);
  }

  List<AnnotationTypes> get pluginAnnotations {
    final List<AnnotationTypes> annotations = <AnnotationTypes>[];

    for (final AnnotationTypes a in AnnotationTypes.values) {
      if (getAnnotation(a) != null) {
        annotations.add(a);
      }
    }

    return annotations;
  }
}

extension AnnotationX on Annotation {
  SourceRange get sourceRange => SourceRange(beginToken.offset, endToken.end - beginToken.offset);

  bool isPluginAnnotation(AnnotationTypes type) {
    return element?.name == type.name;
  }

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

  /// Returns the matched [AnnotationTypes]
  AnnotationTypes? get pluginAnnotation {
    for (final AnnotationTypes a in AnnotationTypes.values) {
      if (a.name == name.name) {
        return a;
      }
    }

    return null;
  }
}
