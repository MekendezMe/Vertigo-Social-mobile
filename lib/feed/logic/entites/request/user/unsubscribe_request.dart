import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class UnsubscribeRequest extends IRequest {
  final int userId;

  UnsubscribeRequest({required this.userId});
  @override
  String get method => "users/$userId/subscribe";

  @override
  HttpMethod get httpMethod => HttpMethod.delete;
}
