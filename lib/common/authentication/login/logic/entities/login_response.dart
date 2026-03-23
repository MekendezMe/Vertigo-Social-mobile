class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String deviceId;
  final int userId;
  final String name;
  final String? username;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.deviceId,
    required this.userId,
    required this.name,
    this.username,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      deviceId: json['device_id'] as String,
      userId: json['user_id'] as int,
      name: json['name'] as String,
      username: json['username'] as String?,
    );
  }
}
