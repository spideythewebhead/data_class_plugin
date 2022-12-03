import 'dart:io';

import 'package:data_class_plugin/src/utils/logger/ansi.dart';
import 'package:data_class_plugin/src/utils/logger/logger.dart';
import 'package:path/path.dart';

class FileLogger extends Logger {
  FileLogger() {
    final String logFilePath = _getFilePath();
    final File logFile = File(logFilePath)..createSync();
    _fileSink = logFile.openWrite();
  }

  late final IOSink _fileSink;

  @override
  void write([final Object? object]) {
    _fileSink.write(object ?? '');
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
    await _fileSink.flush();
    await _fileSink.close();
  }

  @override
  void logHeader(
    String title, {
    String? subtitle,
    LineStyle lineStyle = LineStyle.single,
    int lineLength = 50,
  }) {
    final String line = Ansi.horizontalLine(
      length: lineLength,
      style: lineStyle,
    );

    writeln(line);
    writeln(title.padLeft((title.length + lineLength) ~/ 2));

    if (subtitle != null && subtitle.isNotEmpty) {
      writeln(subtitle.padLeft((subtitle.length + lineLength) ~/ 2));
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
        _fileSink.writeln('${DateTime.now()}\t${severity.name.toUpperCase().padRight(10)}\t$line');
      });
      return;
    }

    _fileSink.writeln('${DateTime.now()}\t${severity.name.toUpperCase()}');
  }
}
