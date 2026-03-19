class RegisterResponse {
  final String accessToken;
  final String refreshToken;
  final String deviceId;

  RegisterResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.deviceId,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      deviceId: json['device_id'] as String,
    );
  }
}
