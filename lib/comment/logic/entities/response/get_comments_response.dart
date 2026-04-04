import 'package:social_network_flutter/feed/logic/entites/comment.dart';
import 'package:social_network_flutter/feed/logic/entites/post.dart' show Post;

class GetCommentsResponse {
  final Post post;
  final List<Comment> comments;
  final bool lastPage;

  GetCommentsResponse({
    required this.comments,
    required this.post,
    required this.lastPage,
  });

  factory GetCommentsResponse.fromJson(Map<String, dynamic> json) {
    return GetCommentsResponse(
      post: Post.fromJson(json['post']),
      comments: (json['comments'] as List)
          .map((e) => Comment.fromJson(e))
          .toList(),
      lastPage: json['last_page'] as bool,
    );
  }
}
