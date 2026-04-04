import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class GetAnswersRequest extends IRequest {
  final int commentId;

  GetAnswersRequest({required this.commentId});
  @override
  HttpMethod get httpMethod => HttpMethod.get;

  @override
  String get method => "comments/{commentId}/answers";

  Map<String, dynamic> paramsIntoPath() {
    return {"commentId": commentId};
  }
}
