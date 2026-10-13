class RefreshTokenResponse {
  final String accessToken;

  /// Nuevo refresh token si el backend lo rota (puede venir vacío).
  final String refreshToken;

  const RefreshTokenResponse({
    required this.accessToken,
    this.refreshToken = '',
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      RefreshTokenResponse(
        accessToken: (json['accessToken'] ?? json['access'] ?? '').toString(),
        refreshToken: (json['refreshToken'] ?? json['refresh'] ?? '')
            .toString(),
      );
}
