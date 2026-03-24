import 'package:social_network_flutter/feed/logic/entites/post.dart';
import 'package:social_network_flutter/feed/logic/entites/user.dart';

class GetPostsResponse {
  final List<Post> posts;
  final User user;

  factory GetPostsResponse.fromJson(Map<String, dynamic> json) {
    return GetPostsResponse(
      posts: (json['posts'] as List)
          .map((item) => Post.fromJson(item))
          .toList(),
      user: User.fromJson(json['user']),
    );
  }

  GetPostsResponse({required this.posts, required this.user});
}
