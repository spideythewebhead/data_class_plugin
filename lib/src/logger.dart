import 'package:analyzer_plugin/channel/channel.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';
import 'package:stack_trace/stack_trace.dart';

class Logger {
  PluginCommunicationChannel? _channel;
  set channel(final PluginCommunicationChannel value) {
    _channel = value;
  }

  void notification(final Object message) {
    // TODO: Replace PluginErrorParams
    // https://github.com/JetBrains/intellij-plugins/blob/master/Dart/resources/messages/DartBundle.properties
    //
    _channel!.sendNotification(
      PluginErrorParams(
        false,
        '$message',
        '',
      ).toNotification(),
    );

    // _channel!.sendNotification(
    //   AnalysisErrorsParams('', <AnalysisError>[
    //     AnalysisError(
    //       AnalysisErrorSeverity.INFO,
    //       AnalysisErrorType.HINT,
    //       Location('', 0, 1, 1, 1),
    //       '$message',
    //       'code',
    //     )
    //   ]).toNotification(),
    // );
  }

  void error(final Object e, [final StackTrace? st]) {
    _channel!.sendNotification(
      PluginErrorParams(
        false,
        'An exception was thrown: $e',
        (st ?? Trace(<Frame>[Trace.current(1).frames[0]])).toString(),
      ).toNotification(),
    );
  }

  void hint(
    final String path,
    final String message, {
    final String code = 'data_class_plugin',
    final Location? location,
    final List<DiagnosticMessage>? messages,
    final String? url,
  }) {
    final Location defaultLocation = location ?? Location(path, 0, 1, 1, 1);

    _channel!.sendNotification(
      AnalysisErrorsParams(path, <AnalysisError>[
        AnalysisError(
          AnalysisErrorSeverity.INFO,
          AnalysisErrorType.LINT,
          defaultLocation,
          message,
          code,
          contextMessages: messages,
          url: url,
        )
      ]).toNotification(),
    );
  }
}
