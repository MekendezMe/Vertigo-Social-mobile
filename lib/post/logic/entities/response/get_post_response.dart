import 'package:social_network_flutter/post/logic/entities/post.dart';

class GetPostResponse {
  final Post post;

  GetPostResponse({required this.post});
  factory GetPostResponse.fromJson(Map<String, dynamic> json) {
    return GetPostResponse(post: Post.fromJson(json));
  }
}
