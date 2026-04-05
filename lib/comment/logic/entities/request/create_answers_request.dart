import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class CreateAnswersRequest extends IRequest {
  final int commentId;
  final int userId;
  final String content;
  final int postId;

  CreateAnswersRequest({
    required this.commentId,
    required this.userId,
    required this.content,
    required this.postId,
  });
  @override
  HttpMethod get httpMethod => HttpMethod.post;

  @override
  String get method => "comments/{commentId}/answers";

  Map<String, dynamic> paramsIntoPath() {
    return {"commentId": commentId};
  }

  Map<String, dynamic> toJson() {
    return {"answer_user_id": userId, "content": content, "post_id": postId};
  }
}
