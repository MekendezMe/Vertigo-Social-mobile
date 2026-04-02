import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class GetCurrentUserRequest extends IRequest {
  @override
  String get method => "users/me";

  @override
  HttpMethod get httpMethod => HttpMethod.get;
}
