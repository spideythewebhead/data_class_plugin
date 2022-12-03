import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:data_class_plugin/src/analyzer_plugin/analyzer_plugin.dart';
import 'package:data_class_plugin/src/analyzer_plugin/web_socket_plugin_server.dart';
import 'package:path/path.dart';

void main(List<String> args) async {
  final DataClassPlugin plugin = DataClassPlugin(
    PhysicalResourceProvider.INSTANCE,
  );
  plugin.start(WebSocketPluginServer());

  final String projectPath = Directory.current.path;
  final String path = join(projectPath, r'example\lib\data_class\default_data_class.dart');

  final AnalysisContextCollection analysis = AnalysisContextCollection(
    includedPaths: <String>[path],
    resourceProvider: PhysicalResourceProvider.INSTANCE,
  );

  await plugin.analyzeFile(
    analysisContext: analysis.contextFor(path),
    path: path,
  );
}
