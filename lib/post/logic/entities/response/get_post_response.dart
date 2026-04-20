import 'package:social_network_flutter/comment/logic/entities/comment.dart';
import 'package:social_network_flutter/post/logic/entities/post.dart';

class GetPostResponse {
  final Post post;
  final List<Comment> comments;

  GetPostResponse({required this.post, required this.comments});
  factory GetPostResponse.fromJson(Map<String, dynamic> json) {
    return GetPostResponse(
      post: Post.fromJson(json['post']),
      comments: (json['comments'] as List)
          .map((e) => Comment.fromJson(e))
          .toList(),
    );
  }
}
