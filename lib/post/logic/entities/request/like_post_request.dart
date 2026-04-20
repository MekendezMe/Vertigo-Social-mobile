import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class LikePostRequest extends IRequest {
  @override
  String get method => 'posts/$postId/like';
  @override
  HttpMethod get httpMethod => HttpMethod.post;

  final int postId;

  LikePostRequest({required this.postId});

  Map<String, dynamic> toJson() {
    return {"post_id": postId};
  }
}
