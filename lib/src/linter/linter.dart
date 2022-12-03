import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart' as protocol;
import 'package:data_class_plugin/src/annotations/data_class_internal.dart';
import 'package:data_class_plugin/src/constants.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/logger.dart';

class PluginLinter {
  const PluginLinter(this._logger);

  final Logger _logger;

  Future<void> check(
    final String path,
    final AnalysisContext analysisContext,
  ) async {
    final ResolvedUnitResult unitResult = await analysisContext.currentSession
        .getResolvedUnit(path)
        .then((SomeResolvedUnitResult value) => value as ResolvedUnitResult);

    for (final CompilationUnitMember declaration in unitResult.unit.declarations) {
      final List<Annotation> annotations = declaration.metadata.annotations;

      if (declaration.declaredElement == null) {
        return;
      }

      for (final Annotation annotation in annotations) {
        final PluginAnnotations? pluginAnnotation = annotation.pluginAnnotation;
        if (pluginAnnotation == null) {
          continue;
        }

        final protocol.Location location = annotation.getLocation(
          path: path,
          unit: unitResult,
        );

        _logger.hint(
          path,
          annotation.toString(),
          location: location,
          url: pluginAnnotation.url,
          messages: <protocol.DiagnosticMessage>[
            protocol.DiagnosticMessage(
              pluginAnnotation.description,
              location,
            ),
          ],
        );

        switch (pluginAnnotation) {
          case PluginAnnotations.dataClass:
            // checkDataClass(declaration as ClassDeclaration);
            break;

          case PluginAnnotations.union:
            checkUnion(path, analysisContext);
            break;

          case PluginAnnotations.enumeration:
            checkEnum(path, analysisContext);
            break;

          case PluginAnnotations.unionFieldValue:
          case PluginAnnotations.jsonKey:
            break;
        }
      }
    }
  }

  void checkDataClass(final ClassDeclaration declaration) {
    final ClassElement element = declaration.declaredElement!;

    final DataClassInternal dataClassAnnotation = DataClassInternal.fromDartObject(
      element.metadata
          .firstWhere((ElementAnnotation annotation) => annotation.isDataClassAnnotation)
          .computeConstantValue(),
    );

    final SourceRange? constructorSourceRange =
        declaration.members.getSourceRangeForConstructor(null);

    if (constructorSourceRange == null) {
      // TODO: Show warning
    }

    if (dataClassAnnotation.copyWith == true &&
        // TODO: Check configuration for overrides
        declaration.members.getSourceRangeForMethod(DataClassMethods.copyWith.name) == null) {
      // TODO: Show error
    }
  }

  void checkUnion(final String path, final AnalysisContext analysisContext) {}

  void checkEnum(final String path, final AnalysisContext analysisContext) {}
}
