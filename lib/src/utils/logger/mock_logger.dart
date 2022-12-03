import 'package:data_class_plugin/src/utils/logger/ansi.dart';
import 'package:data_class_plugin/src/utils/logger/logger.dart';

class MockLogger extends Logger {
  @override
  Future<void> dispose() async {}

  @override
  void error(
    Object? error, [
    StackTrace? st,
    bool isFatal = false,
  ]) {}

  @override
  void exception(
    Object? error, [
    StackTrace? st,
    bool isFatal = false,
  ]) {}

  @override
  void info([Object? object]) {}

  @override
  void logHeader(
    String title, {
    String? subtitle,
    LineStyle lineStyle = LineStyle.single,
    int lineLength = 50,
  }) {}

  @override
  void warning([Object? object]) {}

  @override
  void write([Object? object]) {}

  @override
  void writeln([Object? object]) {}
}
