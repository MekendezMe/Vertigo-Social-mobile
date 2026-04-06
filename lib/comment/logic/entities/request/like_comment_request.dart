import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class LikeCommentRequest extends IRequest {
  @override
  String get method => 'comments/{commentId}/like';
  @override
  HttpMethod get httpMethod => HttpMethod.post;

  final int commentId;

  LikeCommentRequest({required this.commentId});

  Map<String, dynamic> toJson() {
    return {"comment_id": commentId};
  }

  Map<String, dynamic> paramsIntoPath() {
    return {"commentId": commentId};
  }
}
