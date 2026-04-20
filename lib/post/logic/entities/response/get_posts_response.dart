import 'package:social_network_flutter/post/logic/entities/post.dart';

class GetPostsResponse {
  final List<Post> posts;
  final bool isLastPage;

  factory GetPostsResponse.fromJson(Map<String, dynamic> json) {
    return GetPostsResponse(
      posts: (json['posts'] as List)
          .map((item) => Post.fromJson(item))
          .toList(),
      isLastPage: json['last_page'],
    );
  }

  GetPostsResponse({required this.posts, required this.isLastPage});
}
