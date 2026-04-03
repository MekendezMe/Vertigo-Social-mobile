import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class GetPostsRequest extends IRequest {
  final int pageNumber;

  Map<String, dynamic> queryParamsToJson() {
    return {'page_number': pageNumber};
  }

  GetPostsRequest({required this.pageNumber});
  @override
  String get method => "posts/";
  @override
  HttpMethod get httpMethod => HttpMethod.get;
}
