part of 'api_service.dart';

/// Modifies http requests and responses. Used to
/// * Add headers
/// * Modify data
/// * Refresh tokens
@LazySingleton()
interface class AuthInterceptor extends Interceptor {
  // Access the session service lazily via the locator to break circular DI.
  SessionService get _sessionManager => SessionUtil.I;
  final Dio _dio = Dio();

  /// Renovación compartida (single-flight) con el resto de clientes HTTP.
  TokenRefresher get _tokenRefresher => GetIt.I<TokenRefresher>();

  static const _retryFlag = '_authRetried';

  AuthInterceptor(AppConfig appConfig) {
    _dio.options.baseUrl = appConfig.apiBaseUrl;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    /// Add authorization token if the user is logged in
    if (_sessionManager.isLoggedIn) {
      if (kDebugMode) log("AuthInterceptor: Adding token to ${options.path}");
      options.headers["Authorization"] =
          "Bearer ${_sessionManager.accessToken}";
    } else {
      if (kDebugMode)
        log(
          "AuthInterceptor: User not logged in, skipping token for ${options.path}",
        );
    }

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final isUnauthorized = err.response?.statusCode == 401;
    final isAuthCall =
        options.path.contains(ApiEndpoints.refreshToken) ||
        options.path.contains(ApiEndpoints.login);
    final alreadyRetried = options.extra[_retryFlag] == true;

    if (!isUnauthorized ||
        isAuthCall ||
        alreadyRetried ||
        _sessionManager.refreshToken.isEmpty) {
      return handler.next(err);
    }

    final refreshed = await _refreshOnce();
    if (!refreshed) return handler.next(err);

    try {
      final response = await _retryRequest(options);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    } catch (e) {
      handler.next(DioException(requestOptions: options, error: e));
    }
  }

  Future<bool> _refreshOnce() => _tokenRefresher.refresh();

  Future<Response> _retryRequest(RequestOptions requestOptions) {
    // Reutiliza las opciones originales (baseUrl, contentType,
    // responseType, timeouts…) con el nuevo token.
    final options = requestOptions.copyWith(
      headers: {
        ...requestOptions.headers,
        "Authorization": "Bearer ${_sessionManager.accessToken}",
      },
      extra: {...requestOptions.extra, _retryFlag: true},
    );
    return _dio.fetch(options);
  }
}


/// Stores failed dio request's data
class DioRequestData {
  final DioException error;
  final ErrorInterceptorHandler handler;

  const DioRequestData({required this.error, required this.handler});
}
