import 'package:social_network_flutter/comment/logic/entities/comment.dart';

class CreateAnswersResponse {
  final Comment answer;

  factory CreateAnswersResponse.fromJson(Map<String, dynamic> json) {
    return CreateAnswersResponse(answer: Comment.fromJson(json));
  }

  CreateAnswersResponse({required this.answer});
}
