import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class UnlikePostRequest extends IRequest {
  @override
  String get method => 'posts/$postId/like';
  @override
  HttpMethod get httpMethod => HttpMethod.delete;

  final int postId;

  UnlikePostRequest({required this.postId});

  // Map<String, dynamic> toJson() {
  //   return {"post_id": postId};
  // }
}
