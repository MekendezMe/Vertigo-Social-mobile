import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class UnlikeCommentRequest extends IRequest {
  @override
  String get method => 'comments/{commentId}/like';
  @override
  HttpMethod get httpMethod => HttpMethod.delete;

  final int commentId;

  UnlikeCommentRequest({required this.commentId});

  Map<String, dynamic> toJson() {
    return {"comment_id": commentId};
  }

  Map<String, dynamic> paramsIntoPath() {
    return {"commentId": commentId};
  }
}
