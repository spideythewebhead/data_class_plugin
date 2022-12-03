import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';
import 'package:data_class_plugin/src/annotations/constants.dart';
import 'package:data_class_plugin/src/extensions/analyzer_extensions.dart';
import 'package:data_class_plugin/src/extensions/annotation_extensions.dart';
import 'package:data_class_plugin/src/utils/logger/plugin_logger.dart';

export 'data_class_annotation_linter.dart';
export 'enum_annotation_linter.dart';
export 'union_annotation_linter.dart';

abstract class AnnotationLinter {
  AnnotationLinter({
    required this.path,
    required this.logger,
    required this.unitResult,
    required this.declaration,
    required this.pluginAnnotation,
    this.verbose = false,
  }) {
    location = pluginAnnotation.annotation.getLocation(
      path: path,
      unit: unitResult,
    );
  }

  final PluginLogger logger;
  final String path;
  final ResolvedUnitResult unitResult;
  final CompilationUnitMember declaration;
  final PluginAnnotation pluginAnnotation;
  late final Location location;
  final bool verbose;
  late final String name;

  List<String> get hints;

  List<String> get warnings;

  List<String> get errors;

  Future<void> check();

  void showHints(String message, List<String> hints) {
    logger.info(message);
    logger.info('- ${hints.join('\n- ')}');

    logger.showAnalysisHint(
      path,
      message,
      location: location,
      url: pluginAnnotation.type.url,
      messages: hints.map((String e) => DiagnosticMessage(e, location)).toList(growable: false),
    );
  }

  void showWarnings(String message, List<String> warnings) {
    logger.warning(message);
    logger.warning('- ${warnings.join('\n- ')}');

    logger.showAnalysisWarning(
      path,
      message,
      location: location,
      url: pluginAnnotation.type.url,
      messages: warnings.map((String e) => DiagnosticMessage(e, location)).toList(growable: false),
    );
  }

  void showErrors(String message, List<String> errors) {
    logger.error(message);
    logger.error('- ${errors.join('\n- ')}');

    logger.showAnalysisError(
      path,
      message,
      location: location,
      url: pluginAnnotation.type.url,
      messages: errors.map((String e) => DiagnosticMessage(e, location)).toList(growable: false),
    );
  }

  void clear() {
    hints.clear();
    warnings.clear();
    errors.clear();
  }

  void report() {
    if (hints.isNotEmpty) {
      showHints(
        '@${pluginAnnotation.type.name} [$name] has ${hints.length} ${hints.length == 1 ? 'hint' : 'hints'}',
        hints,
      );
    }

    if (warnings.isNotEmpty) {
      showWarnings(
        '@${pluginAnnotation.type.name} [$name] has ${warnings.length} ${warnings.length == 1 ? 'warning' : 'warnings'}',
        warnings,
      );
    }

    if (errors.isNotEmpty) {
      showErrors(
        '@${pluginAnnotation.type.name} [$name] has ${errors.length} ${errors.length == 1 ? 'error' : 'errors'}',
        errors,
      );
    }

    if (hints.isEmpty && warnings.isEmpty && errors.isEmpty) {
      logger.writeln('✅ @${pluginAnnotation.type.name} [$name] is up-to-date');
    }
  }

  void checkConstructor({
    required final AnnotationArgs args,
    required final bool? value,
    required final NodeList<ClassMember> members,
  }) {
    final bool shouldHaveMethod = value ?? args.defaultValue;
    final bool hasMethod = members.getSourceRangeForConstructor(args.name) != null;

    if (shouldHaveMethod && !hasMethod) {
      errors.add('Missing ${args.name}');
    }
  }

  void checkMethod({
    required final AnnotationArgs args,
    required final bool? value,
    required final NodeList<ClassMember> members,
  }) {
    final bool shouldHaveMethod = value ?? args.defaultValue;
    final bool hasMethod = members.getSourceRangeForMethod(args.name) != null;

    if (shouldHaveMethod && !hasMethod) {
      warnings.add('Missing ${args.name}');
    }
  }
}
