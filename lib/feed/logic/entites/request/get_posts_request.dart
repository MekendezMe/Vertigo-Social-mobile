import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class GetPostsRequest extends IRequest {
  @override
  String get method => "feed/posts";
  @override
  HttpMethod get httpMethod => HttpMethod.get;
}
