import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class TokenRequest extends IRequest {
  final String refreshToken;

  TokenRequest({required this.refreshToken});

  factory TokenRequest.fromJson(Map<String, dynamic> json) {
    return TokenRequest(refreshToken: json['refresh_token'] as String);
  }
  Map<String, dynamic> toJson() {
    return {'refresh_token': refreshToken};
  }

  @override
  String get method => "auth/refresh";
  @override
  HttpMethod get httpMethod => HttpMethod.post;
}
