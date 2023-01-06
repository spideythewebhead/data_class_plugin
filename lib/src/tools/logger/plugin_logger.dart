import 'dart:io';

import 'package:analyzer_plugin/channel/channel.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';
import 'package:data_class_plugin/src/tools/logger/ansi.dart';
import 'package:data_class_plugin/src/tools/logger/console_logger.dart';
import 'package:data_class_plugin/src/tools/logger/file_logger.dart';
import 'package:data_class_plugin/src/tools/logger/logger.dart';
import 'package:stack_trace/stack_trace.dart';

class PluginLogger extends Logger {
  PluginLogger({
    final IOSink? ioSink,
  }) {
    registerLogger(ConsoleLogger(ioSink));
  }

  PluginCommunicationChannel? channel;

  set writeToFile(bool value) {
    if (value) {
      registerLogger(FileLogger());
    } else {
      unregisterLogger(FileLogger);
    }
  }

  final List<Logger> _loggers = <Logger>[];
  void registerLogger(Logger logger) {
    _loggers.add(logger);
  }

  void unregisterLogger(Type type) {
    _loggers.removeWhere((Logger l) => l.runtimeType == type);
  }

  @override
  void write([final Object? object]) {
    for (final Logger logger in _loggers) {
      logger.write(object);
    }
  }

  @override
  void writeln([final Object? object]) {
    for (final Logger logger in _loggers) {
      logger.writeln(object);
    }
  }

  @override
  void info([final Object? object]) {
    for (final Logger logger in _loggers) {
      logger.info(object);
    }
  }

  @override
  void debug([final Object? object]) {
    for (final Logger logger in _loggers) {
      logger.debug(object);
    }
  }

  @override
  void warning([final Object? object]) {
    for (final Logger logger in _loggers) {
      logger.warning(object);
    }
  }

  @override
  void error(
    final Object? error, [
    final StackTrace? st,
    final bool isFatal = false,
  ]) {
    for (final Logger logger in _loggers) {
      logger.error(error, st, isFatal);
    }
  }

  @override
  void exception(
    final Object? error, [
    final StackTrace? st,
    final bool isFatal = true,
  ]) {
    final StackTrace stackTrace = st ?? Trace(<Frame>[Trace.current(1).frames[0]]);

    for (final Logger logger in _loggers) {
      logger.exception(error, st, isFatal);
    }

    _showErrorNotification(
      'An exception was thrown: $error',
      isFatal: isFatal,
      stackTrace: stackTrace,
    );
  }

  void notification(final Object message) {
    info(message);

    // TODO: Replace PluginErrorParams
    // https://github.com/JetBrains/intellij-plugins/blob/master/Dart/resources/messages/DartBundle.properties
    //
    // _channel?.sendNotification(
    //   Notification(
    //     'daemon.logMessage',
    //     <String, Object>{
    //       'level': 'info',
    //       'title': 'Data Class Plugin',
    //       'message': message,
    //     },
    //   ),
    // );

    _showErrorNotification(
      message.toString(),
      isFatal: false,
    );
  }

  void _showErrorNotification(
    final String error, {
    final StackTrace? stackTrace,
    final bool isFatal = true,
  }) {
    channel?.sendNotification(
      PluginErrorParams(
        isFatal,
        error,
        stackTrace.toString(),
      ).toNotification(),
    );
  }

  void showAnalysisHint(
    final String path,
    final String message, {
    final String? code,
    final Location? location,
    final List<DiagnosticMessage>? messages,
    final String? url,
  }) {
    showAnalysisMessage(
      path,
      message,
      severity: AnalysisErrorSeverity.INFO,
      type: AnalysisErrorType.HINT,
      messages: messages,
      url: url,
      code: code,
      location: location,
    );
  }

  void showAnalysisWarning(
    final String path,
    final String message, {
    final String? code,
    final Location? location,
    final List<DiagnosticMessage>? messages,
    final String? url,
  }) {
    showAnalysisMessage(
      path,
      message,
      severity: AnalysisErrorSeverity.WARNING,
      type: AnalysisErrorType.STATIC_WARNING,
      messages: messages,
      url: url,
      code: code,
      location: location,
    );
  }

  void showAnalysisError(
    final String path,
    final String message, {
    final String? code,
    final Location? location,
    final List<DiagnosticMessage>? messages,
    final String? url,
  }) {
    showAnalysisMessage(
      path,
      message,
      severity: AnalysisErrorSeverity.ERROR,
      type: AnalysisErrorType.COMPILE_TIME_ERROR,
      messages: messages,
      url: url,
      code: code,
      location: location,
    );
  }

  void showAnalysisMessage(
    final String path,
    final String message, {
    required final AnalysisErrorSeverity severity,
    required final AnalysisErrorType type,
    final String? code,
    final Location? location,
    final List<DiagnosticMessage>? messages,
    final String? url,
  }) {
    final Location defaultLocation = location ?? Location(path, 0, 1, 1, 1);

    channel?.sendNotification(
      AnalysisErrorsParams(path, <AnalysisError>[
        AnalysisError(
          severity,
          type,
          defaultLocation,
          message,
          code ?? 'data_class_plugin_error',
          contextMessages: messages,
          url: url,
        )
      ]).toNotification(),
    );
  }

  @override
  void logHeader(LogHeader header) {
    for (final Logger logger in _loggers) {
      logger.logHeader(header);
    }
  }

  static LogHeader pluginHeader() {
    return LogHeader(
      title: 'Data Class Plugin',
      subtitle: 'Code generation. Same, but different.',
      lineStyle: HorizontalLineStyle.double,
      lineLength: 70,
    );
  }

  @override
  Future<void> dispose() async {
    for (final Logger logger in _loggers) {
      await logger.dispose();
    }
  }
}
