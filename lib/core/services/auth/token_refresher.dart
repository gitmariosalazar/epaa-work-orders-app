import 'dart:developer';

import 'package:clean_architecture/config/app_config.dart';
import 'package:clean_architecture/core/constants/api_endpoints.dart';
import 'package:clean_architecture/core/data/models/requests/refresh_token_request.dart';
import 'package:clean_architecture/core/data/models/responses/refresh_token_response.dart';
import 'package:clean_architecture/core/services/session/session_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

/// Renueva el access token usando el refresh token almacenado.
///
/// Abstracción única (SRP/DIP) compartida por todos los clientes HTTP
/// (Dio `AuthInterceptor` y `AuthHttpClient` de `package:http`), de modo que
/// ningún módulo quede sin renovación automática.
abstract interface class TokenRefresher {
  /// Devuelve `true` si se obtuvo un token nuevo. Si falla, limpia la sesión
  /// (lo que redirige a Login).
  Future<bool> refresh();
}

/// Implementación single-flight: llamadas concurrentes esperan el mismo
/// Future (equivalente a `TokenRefreshCoordinator` de epaa-web). Evita que
/// dos refresh simultáneos invaliden el refresh token rotado.
@LazySingleton(as: TokenRefresher)
final class TokenRefresherImpl implements TokenRefresher {
  TokenRefresherImpl(AppConfig appConfig)
    : _dio = Dio(BaseOptions(baseUrl: appConfig.apiBaseUrl));

  /// Dio sin interceptores → nunca reentra en el manejo de 401.
  final Dio _dio;
  Future<bool>? _inFlight;

  // Acceso perezoso para romper la dependencia circular de DI.
  SessionService get _session => GetIt.I<SessionService>();

  @override
  Future<bool> refresh() =>
      _inFlight ??= _perform().whenComplete(() => _inFlight = null);

  Future<bool> _perform() async {
    final storedRefresh = _session.refreshToken;
    if (storedRefresh.isEmpty) {
      _session.clearSessionData();
      return false;
    }

    try {
      final response = await _dio.post(
        ApiEndpoints.refreshToken,
        data: RefreshTokenRequest(refreshToken: storedRefresh).toJson(),
      );
      final body = response.data;
      final data = body is Map<String, dynamic> ? body['data'] : null;
      if (data is Map<String, dynamic>) {
        final tokens = RefreshTokenResponse.fromJson(data);
        if (tokens.accessToken.isNotEmpty) {
          await _session.refreshAccessToken(
            tokens.accessToken,
            refreshToken: tokens.refreshToken,
          );
          if (kDebugMode) log('TokenRefresher: token renovado');
          return true;
        }
      }
    } catch (e) {
      if (kDebugMode) log('TokenRefresher: fallo al renovar → $e');
    }

    _session.clearSessionData();
    return false;
  }
}
