import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:analyzer_plugin/channel/channel.dart';
import 'package:analyzer_plugin/protocol/protocol.dart';

// https://simonbinder.eu/posts/debugging_analysis_server_plugins/

class WebSocketPluginServer implements PluginCommunicationChannel {
  final dynamic address;
  final int port;

  late HttpServer server;

  WebSocket? _currentClient;
  final StreamController<WebSocket?> _clientStream = StreamController<WebSocket?>.broadcast();

  WebSocketPluginServer({dynamic address, this.port = 9999})
      : address = address ?? InternetAddress.loopbackIPv4 {
    _init();
  }

  Future<void> _init() async {
    server = await HttpServer.bind(address, port);
    print('listening on $address at port $port');
    server.transform(WebSocketTransformer()).listen(_handleClientAdded);
  }

  void _handleClientAdded(WebSocket socket) {
    if (_currentClient != null) {
      print('ignoring connection attempt because an active client already '
          'exists');
      socket.close();
    } else {
      print('client connected');
      _currentClient = socket;
      _clientStream.add(_currentClient!);
      _currentClient!.done.then((_) {
        print('client disconnected');
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
        print('I: $data');
        onRequest(Request.fromJson(jsonEncode(data as String) as Map<String, dynamic>));
      });
    });
    stream.firstWhere((WebSocket? socket) => socket == null).then((_) => onDone!());
  }

  @override
  void sendNotification(Notification notification) {
    print('N: ${notification.toJson()}');
    _currentClient?.add(jsonEncode(notification.toJson()));
  }

  @override
  void sendResponse(Response response) {
    print('O: ${response.toJson()}');
    _currentClient?.add(jsonEncode(response.toJson()));
  }
}
