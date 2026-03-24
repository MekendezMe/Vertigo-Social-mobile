import 'package:social_network_flutter/feed/logic/entites/post.dart';

class CreatePostResponse {
  final Post post;

  CreatePostResponse({required this.post});

  factory CreatePostResponse.fromJson(Map<String, dynamic> json) {
    return CreatePostResponse(post: Post.fromJson(json['post']));
  }
}
