import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/json_key_name_convention.dart';
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as path;

JsonKeyNameConvention getJsonKeyNameConvention({
  required String? nameConvention,
  required final String targetFileRelativePath,
  required final DataClassPluginOptions pluginOptions,
}) {
  nameConvention ??= pluginOptions.json.nameConventionGlobs.entries
      .firstWhereOrNull((MapEntry<String, List<String>> e) {
        return null !=
            e.value.firstWhereOrNull((String glob) => Glob(glob).matches(targetFileRelativePath));
      })
      ?.key
      .snakeCaseToCamelCase();

  nameConvention ??= pluginOptions.json.keyNameConvention?.snakeCaseToCamelCase() ??
      JsonKeyNameConvention.camelCase.name;

  return JsonKeyNameConvention.fromJson(nameConvention);
}

File getDataClassPluginOptionsFile(String root) {
  return File(path.join(root, 'data_class_plugin_options.yaml'));
}

void addPartDirective({
  required String targetFilePath,
  required DartFileEditBuilder fileEditBuilder,
  required List<Directive> directives,
  required List<PartElement> partElements,
}) {
  final String targetPartName = path.basename(targetFilePath).replaceFirst('.dart', '.gen.dart');

  bool shouldAddPart = true;
  for (final PartElement part in partElements) {
    final DirectiveUri partUri = part.uri;
    if (partUri is DirectiveUriWithRelativeUri) {
      if (targetPartName == partUri.relativeUriString) {
        shouldAddPart = false;
        break;
      }
    }
  }

  if (shouldAddPart) {
    final Directive? lastDirective = directives.lastWhereOrNull(
        (Directive directive) => directive is ExportDirective || directive is ImportDirective);
    if (lastDirective != null) {
      fileEditBuilder.addInsertion(
        2 + (lastDirective as NamespaceDirective).semicolon.offset,
        (DartEditBuilder builder) {
          builder
            ..writeln()
            ..writeln("part '$targetPartName';");
        },
      );
    }
  }
}
