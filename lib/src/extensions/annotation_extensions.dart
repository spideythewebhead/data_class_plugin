import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart' as protocol;
import 'package:data_class_plugin/src/constants.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';

extension ElementX on Element {
  bool get hasDataClassAnnotation => dataClassAnnotation != null;
  ElementAnnotation? get dataClassAnnotation => metadata.getAnnotation(PluginAnnotations.dataClass);

  bool get hasUnionAnnotation => unionAnnotation != null;
  ElementAnnotation? get unionAnnotation => metadata.getAnnotation(PluginAnnotations.union);

  bool get hasEnumAnnotation => enumAnnotation != null;
  ElementAnnotation? get enumAnnotation => metadata.getAnnotation(PluginAnnotations.enumeration);
}

extension ClassDeclarationX on ClassDeclaration {
  bool get hasDataClassAnnotation => dataClassAnnotation != null;
  Annotation? get dataClassAnnotation => metadata.getAnnotation(PluginAnnotations.dataClass);

  bool get hasUnionAnnotation => unionAnnotation != null;
  Annotation? get unionAnnotation => metadata.getAnnotation(PluginAnnotations.union);

  List<Annotation> get annotations => metadata.annotations;
}

extension EnumDeclarationX on EnumDeclaration {
  bool get hasEnumAnnotation => enumAnnotation != null;
  Annotation? get enumAnnotation => metadata.getAnnotation(PluginAnnotations.enumeration);
}

extension ElementAnnotationX on ElementAnnotation {
  bool get isDataClassAnnotation => element?.displayName == PluginAnnotations.dataClass.name;
  bool get isEnumAnnotation => element?.displayName == PluginAnnotations.enumeration.name;
  bool get isJsonKeyAnnotation => element?.displayName == PluginAnnotations.jsonKey.name;
  bool get isUnionAnnotation => element?.displayName == PluginAnnotations.union.name;
  bool get isUnionFieldValueAnnotation =>
      element?.displayName == PluginAnnotations.unionFieldValue.name;
}

extension ElementAnnotationListX on List<ElementAnnotation> {
  ElementAnnotation? getAnnotation(PluginAnnotations annotation) {
    return firstWhereOrNull((ElementAnnotation a) => a.element?.displayName == annotation.name);
  }
}

extension AnnotationNodeListX on NodeList<Annotation> {
  Annotation? getAnnotation(PluginAnnotations annotation) {
    return firstWhereOrNull((Annotation a) => a.name.name == annotation.name);
  }

  List<Annotation> get annotations {
    return where((Annotation annotation) {
      return PluginAnnotations.values
              .where((PluginAnnotations element) => annotation.name.name == element.name)
              .firstOrNull !=
          null;
    }).toList(growable: false);
  }

  List<PluginAnnotations> get pluginAnnotations {
    final List<PluginAnnotations> annotations = <PluginAnnotations>[];

    for (final PluginAnnotations a in PluginAnnotations.values) {
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

  /// Returns the matched [PluginAnnotations]
  PluginAnnotations? get pluginAnnotation {
    for (final PluginAnnotations a in PluginAnnotations.values) {
      if (a.name == name.name) {
        return a;
      }
    }

    return null;
  }
}
