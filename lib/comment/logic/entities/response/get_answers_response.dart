import 'package:social_network_flutter/comment/logic/entities/comment.dart';

class GetAnswersResponse {
  final Comment parent;
  final List<Comment> answers;
  final bool lastPage;

  GetAnswersResponse({
    required this.answers,
    required this.parent,
    required this.lastPage,
  });

  factory GetAnswersResponse.fromJson(Map<String, dynamic> json) {
    return GetAnswersResponse(
      parent: Comment.fromJson(json['parent']),
      answers: (json['answers'] as List)
          .map((e) => Comment.fromJson(e))
          .toList(),
      lastPage: json['last_page'] as bool,
    );
  }
}
