import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class UnlikePostRequest extends IRequest {
  @override
  String get method => 'feed/removeLikePost';

  final int userId;
  final int postId;

  UnlikePostRequest({required this.userId, required this.postId});

  Map<String, dynamic> toJson() {
    return {"user_id": userId, "post_id": postId};
  }
}
