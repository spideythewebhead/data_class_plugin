import 'dart:io';

import 'package:data_class_plugin/src/utils/logger/ansi.dart';
import 'package:data_class_plugin/src/utils/logger/logger.dart';
import 'package:stack_trace/stack_trace.dart';

class ConsoleLogger extends Logger {
  ConsoleLogger(IOSink? ioSink) : _consoleSink = ioSink ?? stdout;

  final IOSink _consoleSink;

  @override
  void write([final Object? object]) {
    _consoleSink.write(object ?? '');
  }

  @override
  void writeln([final Object? object]) {
    _consoleSink.writeln(object ?? '');
  }

  @override
  void info([final Object? object]) {
    _consoleSink.writeln('$object'.blue());
  }

  @override
  void warning([final Object? object]) {
    _consoleSink.writeln('$object'.yellow());
  }

  @override
  void error(
    final Object? error, [
    final StackTrace? st,
    final bool isFatal = false,
  ]) {
    _consoleSink.writeln('$error'.red());

    if (st != null) {
      _consoleSink.writeln(Ansi.horizontalLine());
      _consoleSink.writeln('Stacktrace:'.red().bold());
      _consoleSink.writeln('$st'.red());
      _consoleSink.writeln(Ansi.horizontalLine());
    }
  }

  @override
  void exception(
    final Object? error, [
    final StackTrace? st,
    final bool isFatal = false,
  ]) {
    _consoleSink.writeln(Ansi.horizontalLine());
    _consoleSink.writeln('An exception was thrown:'.red().bold());
    _consoleSink.writeln(error.toString().red());

    final StackTrace stackTrace = st ?? Trace(<Frame>[Trace.current(1).frames[0]]);
    _consoleSink.writeln(Ansi.horizontalLine());
    _consoleSink.writeln('Stacktrace:'.red().bold());
    _consoleSink.writeln('$stackTrace'.red());
    _consoleSink.writeln(Ansi.horizontalLine());
  }

  @override
  void logHeader(
    final String title, {
    final String? subtitle,
    final LineStyle lineStyle = LineStyle.single,
    final int lineLength = 50,
  }) {
    final String line = Ansi.horizontalLine(
      length: lineLength,
      style: lineStyle,
    ).bold();

    writeln(line);
    writeln(
      title //
          .padLeft((title.length + lineLength) ~/ 2)
          .blue()
          .bold(),
    );

    if (subtitle != null && subtitle.isNotEmpty) {
      writeln(subtitle.padLeft((subtitle.length + lineLength) ~/ 2));
    }
    writeln(line);
  }

  @override
  Future<void> dispose() async {
    await _consoleSink.flush();
    await _consoleSink.close();
  }
}
