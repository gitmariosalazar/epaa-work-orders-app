class RefreshTokenRequest {
  final String refreshToken;

  const RefreshTokenRequest({required this.refreshToken});

  Map<String, String> toJson() => {"refreshToken": refreshToken};
}
