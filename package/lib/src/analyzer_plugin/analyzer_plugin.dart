import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart' as analyzer;
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/file_system/file_system.dart' as analyzer;
import 'package:analyzer_plugin/plugin/assist_mixin.dart';
import 'package:analyzer_plugin/plugin/plugin.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';
// Workaround until DartAssistsMixin can be actually used as a mixin
// ignore: implementation_imports
import 'package:analyzer_plugin/src/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:data_class_plugin/src/contributors/class/class_contributors.dart';
import 'package:data_class_plugin/src/contributors/enum/enum_contributors.dart';

/// A tcp socket that allows to write for debugging purposes
Socket? debugTcpSocket;

class DcpAnalyzerPlugin extends ServerPlugin with AssistsMixin, WorkaroundDartAssistsMixin {
  DcpAnalyzerPlugin(final analyzer.ResourceProvider resourceProvider)
    : super(resourceProvider: resourceProvider) {
    // a simple way to receive logs from a tcp socket
    // 1. start a tcp server, example nc -lk 9000 (or whatever port)
    // 1. uncomment this code, set your port
    // 1. restart dart analysis server
    // 1. expect to receive "DcpAnalyzerPlugin client"
    // Socket.connect('127.0.0.1', 9000)
    //     .then((Socket socket) {
    //       debugTcpSocket = socket;
    //       socket.writeln('DcpAnalyzerPlugin client');
    //     })
    //     .catchError((Object error, StackTrace stackTrace) {
    //       stderr.addError(error, stackTrace);
    //     });
  }

  @override
  List<String> get fileGlobsToAnalyze => const <String>['*.dart'];

  @override
  String get name => 'data_class_plugin';
  String get displayName => '$name v$version';

  @override
  String get contactInfo => 'https://github.com/spideythewebhead/dart_data_class_plugin/issues';

  @override
  String get version => '1.0.0';

  @override
  Future<void> analyzeFile({
    required analyzer.AnalysisContext analysisContext,
    required String path,
  }) async {}

  @override
  List<AssistContributor> getAssistContributors(String path) {
    try {
      return <AssistContributor>[
        // Class contributors
        DataClassAssistContributor(path),

        // Enum contributors
        EnumAnnotationAssistContributor(path),
      ];
    } catch (error, stackTrace) {
      debugTcpSocket?.writeln(error.toString());
      debugTcpSocket?.writeln(stackTrace.toString());
    }
    return <AssistContributor>[];
  }

  // @override
  // Future<PluginShutdownResult> handlePluginShutdown(PluginShutdownParams parameters) async {
  // _logger.notification('Shutting down $displayName');
  // await _logger.dispose();
  // return await super.handlePluginShutdown(parameters);
  // }

  // @override
  // void onError(Object exception, StackTrace stackTrace) {
  // _logger.exception(exception, stackTrace);
  // }
}

// TODO(): Remove once [DartAssistsMixin] can be used
abstract mixin class WorkaroundDartAssistsMixin implements AssistsMixin {
  @override
  Future<AssistRequest> getAssistRequest(
    EditGetAssistsParams parameters,
  ) async {
    final String path = parameters.file;
    final ResolvedUnitResult result = await getResolvedUnitResult(path);
    return DartAssistRequestImpl(
      resourceProvider,
      parameters.offset,
      parameters.length,
      result,
    );
  }
}
