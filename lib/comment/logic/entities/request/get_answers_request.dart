import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class GetAnswersRequest extends IRequest {
  final int commentId;
  final int pageNumber;

  GetAnswersRequest({required this.commentId, required this.pageNumber});
  @override
  HttpMethod get httpMethod => HttpMethod.get;

  @override
  String get method => "comments/$commentId/answers";

  Map<String, dynamic> queryParamsToJson() {
    return {"page_number": pageNumber};
  }
}
