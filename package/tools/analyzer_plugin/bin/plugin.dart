import 'dart:isolate';

import 'package:data_class_plugin/analyzer_plugin.dart';

void main(List<String> args, SendPort sendPort) {
  start(args, sendPort);
}
