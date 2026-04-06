import 'package:social_network_flutter/comment/logic/entities/comment.dart';

class CreateCommentsResponse {
  final Comment comment;

  factory CreateCommentsResponse.fromJson(Map<String, dynamic> json) {
    return CreateCommentsResponse(comment: Comment.fromJson(json));
  }

  CreateCommentsResponse({required this.comment});
}
