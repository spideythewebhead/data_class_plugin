import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:analyzer_plugin/channel/channel.dart';
import 'package:analyzer_plugin/protocol/protocol.dart';
import 'package:data_class_plugin/src/tools/logger/logger.dart';

// https://simonbinder.eu/posts/debugging_analysis_server_plugins/

class WebSocketPluginServer implements PluginCommunicationChannel {
  final dynamic address;
  final int port;

  late HttpServer server;
  final Logger logger;

  WebSocket? _currentClient;
  final StreamController<WebSocket?> _clientStream = StreamController<WebSocket?>.broadcast();

  WebSocketPluginServer({
    required this.logger,
    dynamic address,
    this.port = 9999,
  }) : address = address ?? InternetAddress.loopbackIPv4 {
    _init();
  }

  Future<void> _init() async {
    server = await HttpServer.bind(address, port);
    logger.writeln('> listening on $address at port $port');
    server.transform(WebSocketTransformer()).listen(_handleClientAdded);
  }

  void _handleClientAdded(WebSocket socket) {
    if (_currentClient != null) {
      logger.warning('ignoring connection attempt because an active client already exists');
      socket.close();
    } else {
      logger.writeln('client connected');
      _currentClient = socket;
      _clientStream.add(_currentClient!);
      _currentClient!.done.then((_) {
        logger.warning('client disconnected');
        _currentClient = null;
        _clientStream.add(null);
      });
    }
  }

  @override
  void close() {
    server.close(force: true);
  }

  @override
  void listen(
    void Function(Request request) onRequest, {
    Function? onError,
    void Function()? onDone,
  }) {
    final Stream<WebSocket?> stream = _clientStream.stream;

    // wait until we're connected
    stream.firstWhere((WebSocket? socket) => socket != null).then((_) {
      _currentClient!.listen((dynamic data) {
        // logger.writeln('I: $data');
        onRequest(Request.fromJson(jsonEncode(data as String) as Map<String, dynamic>));
      });
    });
    stream.firstWhere((WebSocket? socket) => socket == null).then((_) => onDone!());
  }

  @override
  void sendNotification(Notification notification) {
    // logger.writeln('N: ${notification.toJson()}');
    _currentClient?.add(jsonEncode(notification.toJson()));
  }

  @override
  void sendResponse(Response response) {
    // logger.writeln('O: ${response.toJson()}');
    _currentClient?.add(jsonEncode(response.toJson()));
  }
}
