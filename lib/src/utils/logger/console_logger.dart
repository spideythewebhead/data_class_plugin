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
  void logHeader(Header header) {
    final String line = Ansi.horizontalLine(
      length: header.lineLength,
      style: header.lineStyle,
    ).bold();

    writeln(line);
    writeln(
      header.title //
          .padLeft((header.title.length + header.lineLength) ~/ 2)
          .blue()
          .bold(),
    );

    if (header.subtitle != null && header.subtitle!.isNotEmpty) {
      writeln(header.subtitle!.padLeft((header.subtitle!.length + header.lineLength) ~/ 2));
    }
    writeln(line);
  }

  @override
  Future<void> dispose() async {
    await _consoleSink.flush();
    await _consoleSink.close();
  }
}
