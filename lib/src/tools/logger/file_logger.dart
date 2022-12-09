import 'dart:io';

import 'package:data_class_plugin/src/tools/logger/ansi.dart';
import 'package:data_class_plugin/src/tools/logger/logger.dart';
import 'package:path/path.dart';

class FileLogger extends Logger {
  FileLogger() {
    final String logFilePath = _getFilePath();
    final File logFile = File(logFilePath)..createSync();
    _sink = logFile.openWrite();
  }

  late final IOSink _sink;

  @override
  void write([final Object? object]) {
    _sink.write(object ?? '');
  }

  @override
  void writeln([final Object? object]) {
    _log(object, LogSeverity.debug);
  }

  @override
  void info([final Object? object]) {
    _log(object, LogSeverity.info);
  }

  @override
  void warning([final Object? object]) {
    _log(object, LogSeverity.warning);
  }

  @override
  void error(
    final Object? error, [
    final StackTrace? st,
    final bool isFatal = false,
  ]) {
    _log(error, LogSeverity.error);

    if (st != null) {
      _log(Ansi.horizontalLine(), LogSeverity.error);
      _log('Stacktrace:', LogSeverity.error);
      _log(st.toString(), LogSeverity.error);
      _log(Ansi.horizontalLine(), LogSeverity.error);
    }
  }

  @override
  void exception(
    final Object? error, [
    final StackTrace? st,
    final bool isFatal = false,
  ]) {
    _log(Ansi.horizontalLine(), LogSeverity.fatal);
    _log('An exception was thrown:', LogSeverity.fatal);
    _log(error, LogSeverity.fatal);

    _log(Ansi.horizontalLine(), LogSeverity.fatal);
    _log('Stacktrace:', LogSeverity.fatal);
    _log(st.toString(), LogSeverity.fatal);
    _log(Ansi.horizontalLine(), LogSeverity.fatal);
  }

  @override
  Future<void> dispose() async {
    await _sink.flush();
    await _sink.close();
  }

  @override
  void logHeader(LogHeader header) {
    final String line = Ansi.horizontalLine(
      length: header.lineLength,
      style: header.lineStyle,
    );

    writeln(line);
    writeln(header.title.padLeft((header.title.length + header.lineLength) ~/ 2));

    if (header.subtitle != null && header.subtitle!.isNotEmpty) {
      writeln(header.subtitle!.padLeft((header.subtitle!.length + header.lineLength) ~/ 2));
    }
    writeln(line);
  }

  String _getFilePath() {
    final DateTime now = DateTime.now();

    final String month = now.month.toString().padLeft(2, '0');
    final String day = now.day.toString().padLeft(2, '0');
    final String hour = now.hour.toString().padLeft(2, '0');
    final String minute = now.minute.toString().padLeft(2, '0');
    final String second = now.second.toString().padLeft(2, '0');

    return join(
      Directory.current.path,
      'logs',
      '${now.year}$month${day}_$hour$minute$second.log',
    );
  }

  void _log(Object? object, LogSeverity severity) {
    if (object != null) {
      object.toString().split('\n').forEach((String line) {
        _sink.writeln('${DateTime.now()}\t${severity.name.toUpperCase().padRight(10)}\t$line');
      });
      return;
    }

    _sink.writeln('${DateTime.now()}\t${severity.name.toUpperCase()}');
  }
}
