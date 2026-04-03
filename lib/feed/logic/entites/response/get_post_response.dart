import 'package:social_network_flutter/feed/logic/entites/post.dart';

class GetPostResponse {
  final Post post;

  factory GetPostResponse.fromJson(Map<String, dynamic> json) {
    return GetPostResponse(post: Post.fromJson(json));
  }

  GetPostResponse({required this.post});
}
