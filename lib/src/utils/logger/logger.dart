import 'package:data_class_plugin/src/utils/logger/ansi.dart';

enum LogSeverity { debug, info, warning, error, fatal }

abstract class Logger {
  void write([final Object? object]);
  void writeln([final Object? object]);

  void info([final Object? object]);
  void warning([final Object? object]);
  void error(
    final Object? error, [
    final StackTrace? st,
    final bool isFatal = false,
  ]);

  void exception(
    final Object? error, [
    final StackTrace? st,
    final bool isFatal = false,
  ]);

  void logHeader(
    final String title, {
    final String? subtitle,
    final LineStyle lineStyle = LineStyle.single,
    final int lineLength = 50,
  });

  Future<void> dispose();
}
