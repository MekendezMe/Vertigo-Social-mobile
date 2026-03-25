import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class GetCurrentUserRequest extends IRequest {
  @override
  String get method => "auth/getProfile";

  @override
  // TODO: implement httpMethod
  HttpMethod get httpMethod => HttpMethod.get;
}
