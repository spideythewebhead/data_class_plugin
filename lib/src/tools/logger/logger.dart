import 'package:data_class_plugin/src/tools/logger/ansi.dart';

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

  void logHeader(LogHeader header);

  Future<void> dispose();
}

class LogHeader {
  /// Shorthand constructor
  LogHeader({
    required this.title,
    this.subtitle,
    this.lineStyle = HorizontalLineStyle.single,
    this.lineLength = 50,
  });

  final String title;
  final String? subtitle;
  final HorizontalLineStyle lineStyle;
  final int lineLength;
}
