import 'package:social_network_flutter/post/logic/entities/post.dart';

class EditPostResponse {
  final Post post;

  EditPostResponse({required this.post});

  factory EditPostResponse.fromJson(Map<String, dynamic> json) {
    return EditPostResponse(post: Post.fromJson(json));
  }
}
