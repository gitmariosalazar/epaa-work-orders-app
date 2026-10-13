import 'dart:async';

import 'package:clean_architecture/core/services/auth/token_refresher.dart';
import 'package:clean_architecture/core/services/session/session_service.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

/// Decorador de [http.Client] (patrón Decorator / OCP) que:
/// * inyecta siempre el access token vigente,
/// * ante un 401 renueva el token vía [TokenRefresher] y reintenta una vez.
///
/// Así los datasources que usan `package:http` (p. ej. incidencias) tienen
/// el mismo comportamiento que los que usan Dio.
class AuthHttpClient extends http.BaseClient {
  AuthHttpClient(this._inner);

  final http.Client _inner;

  SessionService get _session => GetIt.I<SessionService>();
  TokenRefresher get _refresher => GetIt.I<TokenRefresher>();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    _authorize(request);

    // Solo las peticiones con cuerpo en memoria pueden reenviarse.
    final retryable = request is http.Request;
    final snapshot = retryable ? _copy(request) : null;

    final response = await _inner.send(request);
    if (response.statusCode != 401 ||
        snapshot == null ||
        _session.refreshToken.isEmpty) {
      return response;
    }

    // Descarta el cuerpo del 401 y renueva.
    await response.stream.drain<void>();
    final refreshed = await _refresher.refresh();
    if (!refreshed) {
      return http.StreamedResponse(
        Stream.value(const <int>[]),
        401,
        request: request,
        reasonPhrase: 'Unauthorized',
      );
    }

    _authorize(snapshot);
    return _inner.send(snapshot);
  }

  void _authorize(http.BaseRequest request) {
    final token = _session.accessToken;
    if (token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
      request.headers.remove('x-api-key');
    }
  }

  http.Request _copy(http.Request original) {
    return http.Request(original.method, original.url)
      ..headers.addAll(original.headers)
      ..followRedirects = original.followRedirects
      ..maxRedirects = original.maxRedirects
      ..persistentConnection = original.persistentConnection
      ..bodyBytes = original.bodyBytes;
  }

  @override
  void close() => _inner.close();
}
