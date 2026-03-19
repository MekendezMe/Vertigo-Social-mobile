class TokenService {
  String? _accessToken;

  String? get accessToken => _accessToken;

  void setToken(String token) {
    _accessToken = token;
  }
}
