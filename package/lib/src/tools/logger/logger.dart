import 'package:data_class_plugin/src/tools/logger/ansi.dart';

enum LogSeverity { debug, info, warning, error, fatal }

abstract class Logger {
  void write([final Object? object]);
  void writeln([final Object? object]);

  void info([final Object? object]);
  void debug([final Object? object]);
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

  void log(Object? object, LogSeverity? severity) {
    if (object != null) {
      object.toString().split('\n').forEach((String line) {
        if (severity == null) {
          writeln('${DateTime.now()}\t$line');
        } else {
          writeln('${DateTime.now()}\t${severity.name.toUpperCase().padRight(10)}\t$line');
        }
      });
      return;
    }

    if (severity == null) {
      writeln('${DateTime.now()}\t$object');
    } else {
      writeln('${DateTime.now()}\t${severity.name.toUpperCase().padRight(10)}\t$object');
    }
  }

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
