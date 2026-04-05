import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class CreateCommentsRequest extends IRequest {
  final int postId;
  final String content;

  CreateCommentsRequest({required this.postId, required this.content});
  @override
  HttpMethod get httpMethod => HttpMethod.post;

  @override
  String get method => "comments";

  Map<String, dynamic> toJson() {
    return {"post_id": postId, "content": content};
  }
}
