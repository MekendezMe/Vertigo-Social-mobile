import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class GetCommentsRequest extends IRequest {
  final int postId;
  final int pageNumber;

  GetCommentsRequest({required this.postId, required this.pageNumber});
  @override
  HttpMethod get httpMethod => HttpMethod.get;

  @override
  String get method => "posts/$postId/comments";

  Map<String, dynamic> queryParamsToJson() {
    return {"page_number": pageNumber};
  }
}
