import 'dart:async';

import 'package:clean_architecture/config/app_config.dart';
import 'package:clean_architecture/core/services/session/session_service.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'realtime_events.dart';

/// Contrato de tiempo real (DIP / ISP).
abstract interface class WebSocketService {
  ValueListenable<bool> get isConnected;
  ValueListenable<bool> get isReconnectExhausted;

  /// Stream de todos los eventos recibidos.
  Stream<RealtimeEvent> get events;

  /// Stream filtrado por nombre de evento.
  Stream<Map<String, dynamic>> on(String event);

  /// Conecta usando la URL del API y el token de sesión por defecto.
  void connect({String? baseUrl, String? token});
  void emit(String event, [Object? data]);
  void disconnect();
  void dispose();
}

@LazySingleton(as: WebSocketService)
final class SocketIOWebSocketService implements WebSocketService {
  final SessionService _session;
  SocketIOWebSocketService(this._session);

  static const _maxAttempts = 10;

  io.Socket? _socket;
  final _events = StreamController<RealtimeEvent>.broadcast();
  final _isConnected = ValueNotifier<bool>(false);
  final _exhausted = ValueNotifier<bool>(false);

  @override
  ValueListenable<bool> get isConnected => _isConnected;
  @override
  ValueListenable<bool> get isReconnectExhausted => _exhausted;
  @override
  Stream<RealtimeEvent> get events => _events.stream;

  @override
  Stream<Map<String, dynamic>> on(String event) =>
      events.where((e) => e.name == event).map((e) => e.payload);

  String _origin(String url) {
    final uri = Uri.parse(url);
    return '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
  }

  @override
  void connect({String? baseUrl, String? token}) {
    if (_socket?.connected ?? false) return;
    _socket?.dispose();
    _exhausted.value = false;

    final url = '${_origin(baseUrl ?? AppConfigUtil.I.apiBaseUrl)}/realtime';
    final authToken = token ?? _session.accessToken;

    final socket = io.io(
      url,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(_maxAttempts)
          .setReconnectionDelay(3000)
          .setReconnectionDelayMax(30000)
          .setAuth({'token': authToken})
          .build(),
    );

    socket
      ..onConnect((_) {
        _isConnected.value = true;
        _exhausted.value = false;
        debugPrint('[WS] Conectado a $url');
      })
      ..onDisconnect((_) => _isConnected.value = false)
      ..onConnectError((e) => debugPrint('[WS] Error de conexión: $e'))
      ..on('reconnect_failed', (_) => _exhausted.value = true)
      ..onAny((event, data) {
        if (_events.isClosed) return;
        final payload = data is Map
            ? Map<String, dynamic>.from(data)
            : <String, dynamic>{'data': data};
        _events.add(RealtimeEvent(event, payload));
      })
      ..connect();

    _socket = socket;
  }

  @override
  void emit(String event, [Object? data]) => _socket?.emit(event, data);

  @override
  void disconnect() {
    _socket?.dispose();
    _socket = null;
    _isConnected.value = false;
  }

  @override
  @disposeMethod
  void dispose() {
    disconnect();
    _events.close();
    _isConnected.dispose();
    _exhausted.dispose();
  }
}
