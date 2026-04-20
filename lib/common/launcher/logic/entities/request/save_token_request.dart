import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class SaveTokenRequest extends IRequest {
  final String fcmToken;

  SaveTokenRequest({required this.fcmToken});
  @override
  String get method => "users/saveToken";

  @override
  HttpMethod get httpMethod => HttpMethod.post;

  Map<String, dynamic> toJson() {
    return {"fcm_token": fcmToken};
  }
}
