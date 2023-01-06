import 'package:data_class_plugin/src/tools/logger/logger.dart';

class NoOpLogger extends Logger {
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
  void debug([Object? object]) {}

  @override
  void logHeader(LogHeader header) {}

  @override
  void warning([Object? object]) {}

  @override
  void write([Object? object]) {}

  @override
  void writeln([Object? object]) {}
}
