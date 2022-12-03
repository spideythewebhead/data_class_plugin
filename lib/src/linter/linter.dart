import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:data_class_plugin/src/annotations/constants.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/linter/annotation_linter/annotation_linter.dart';
import 'package:data_class_plugin/src/utils/logger/plugin_logger.dart';

class PluginLinter {
  const PluginLinter(this._logger);

  final PluginLogger _logger;

  Future<void> check(
    final String path,
    final AnalysisContext analysisContext,
  ) async {
    final ResolvedUnitResult unitResult = await analysisContext.currentSession
        .getResolvedUnit(path)
        .then((SomeResolvedUnitResult value) => value as ResolvedUnitResult);

    for (final CompilationUnitMember declaration in unitResult.unit.declarations) {
      final List<Annotation> annotations = declaration.metadata.annotations;

      if (declaration.declaredElement == null || annotations.isEmpty) {
        return;
      }

      for (final Annotation annotation in annotations) {
        final AnnotationTypes? type = annotation.pluginAnnotation;
        if (type == null) {
          continue;
        }

        final PluginAnnotation pluginAnnotation = PluginAnnotation(
          annotation: annotation,
          type: type,
        );

        late final AnnotationLinter linter;
        switch (type) {
          case AnnotationTypes.dataClass:
            linter = DataClassAnnotationLinter(
              logger: _logger,
              path: path,
              unitResult: unitResult,
              declaration: declaration,
              pluginAnnotation: pluginAnnotation,
            );
            break;

          case AnnotationTypes.union:
            linter = UnionAnnotationLinter(
              logger: _logger,
              path: path,
              unitResult: unitResult,
              declaration: declaration,
              pluginAnnotation: pluginAnnotation,
            );
            break;

          case AnnotationTypes.enumeration:
            linter = EnumAnnotationLinter(
              logger: _logger,
              path: path,
              unitResult: unitResult,
              declaration: declaration,
              pluginAnnotation: pluginAnnotation,
            );
            break;

          case AnnotationTypes.unionFieldValue:
          case AnnotationTypes.jsonKey:
            continue;
        }

        await linter.check();
      }
    }
  }
}
