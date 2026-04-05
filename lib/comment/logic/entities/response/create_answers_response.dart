import 'package:social_network_flutter/comment/logic/entities/comment.dart';

class CreateAnswersResponse {
  final Comment comment;

  factory CreateAnswersResponse.fromJson(Map<String, dynamic> json) {
    return CreateAnswersResponse(comment: Comment.fromJson(json['comment']));
  }

  CreateAnswersResponse({required this.comment});
}
