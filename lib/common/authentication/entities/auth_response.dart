class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final String deviceId;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.deviceId,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      deviceId: json['device_id'] as String,
    );
  }
}
