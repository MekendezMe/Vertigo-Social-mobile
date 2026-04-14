import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class SubscribeRequest extends IRequest {
  final int userId;

  SubscribeRequest({required this.userId});
  @override
  String get method => "users/$userId/subscribe";

  @override
  HttpMethod get httpMethod => HttpMethod.post;
}
