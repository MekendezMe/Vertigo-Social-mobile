import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class TokenRequest extends IRequest {
  final String refreshToken;
  final String deviceId;

  TokenRequest({required this.refreshToken, required this.deviceId});

  Map<String, dynamic> toJson() {
    return {'refresh_token': refreshToken, 'device_id': deviceId};
  }

  @override
  String get method => "auth/refresh";
  @override
  HttpMethod get httpMethod => HttpMethod.post;
}
