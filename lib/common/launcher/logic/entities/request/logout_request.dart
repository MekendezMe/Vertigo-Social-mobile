import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class LogoutRequest extends IRequest {
  @override
  String get method => "auth/logout";
  @override
  HttpMethod get httpMethod => HttpMethod.post;
}
