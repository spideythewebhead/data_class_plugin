import 'dart:isolate';

import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer_plugin/starter.dart';
import 'package:data_class_plugin/src/analyzer_plugin/analyzer_plugin.dart';

void start(Iterable<String> args, SendPort sendPort) {
  ServerPluginStarter(DataClassPlugin(
    PhysicalResourceProvider.INSTANCE,
  )).start(sendPort);
}
