import 'dart:io';

import 'package:data_class_plugin/src/tools/logger/ansi.dart';
import 'package:data_class_plugin/src/tools/logger/logger.dart';
import 'package:stack_trace/stack_trace.dart';

class ConsoleLogger extends Logger {
  ConsoleLogger(IOSink? ioSink) : _sink = ioSink ?? stdout;

  final IOSink _sink;

  @override
  void write([final Object? object]) {
    _sink.write(object ?? '');
  }

  @override
  void writeln([final Object? object]) {
    _sink.writeln(object ?? '');
  }

  @override
  void info([final Object? object]) {
    _sink.writeln('$object'.blue());
  }

  @override
  void warning([final Object? object]) {
    _sink.writeln('$object'.yellow());
  }

  @override
  void error(
    final Object? error, [
    final StackTrace? st,
    final bool isFatal = false,
  ]) {
    _sink.writeln('$error'.red());

    if (st != null) {
      _sink.writeln(Ansi.horizontalLine());
      _sink.writeln('Stacktrace:'.red().bold());
      _sink.writeln('$st'.red());
      _sink.writeln(Ansi.horizontalLine());
    }
  }

  @override
  void exception(
    final Object? error, [
    final StackTrace? st,
    final bool isFatal = false,
  ]) {
    _sink.writeln(Ansi.horizontalLine());
    _sink.writeln('An exception was thrown:'.red().bold());
    _sink.writeln(error.toString().red());

    final StackTrace stackTrace = st ?? Trace(<Frame>[Trace.current(1).frames[0]]);
    _sink.writeln(Ansi.horizontalLine());
    _sink.writeln('Stacktrace:'.red().bold());
    _sink.writeln('$stackTrace'.red());
    _sink.writeln(Ansi.horizontalLine());
  }

  @override
  void logHeader(LogHeader header) {
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
    await _sink.flush();
    await _sink.close();
  }
}
