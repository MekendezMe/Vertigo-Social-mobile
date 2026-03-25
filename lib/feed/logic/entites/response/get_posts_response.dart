import 'package:social_network_flutter/feed/logic/entites/post.dart';

class GetPostsResponse {
  final List<Post> posts;

  factory GetPostsResponse.fromJson(Map<String, dynamic> json) {
    return GetPostsResponse(
      posts: (json['posts'] as List)
          .map((item) => Post.fromJson(item))
          .toList(),
    );
  }

  GetPostsResponse({required this.posts});
}
