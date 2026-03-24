import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class LikePostRequest extends IRequest {
  @override
  String get method => 'feed/likePost';

  final int userId;
  final int postId;

  LikePostRequest({required this.userId, required this.postId});

  Map<String, dynamic> toJson() {
    return {"user_id": userId, "post_id": postId};
  }
}
