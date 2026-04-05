import 'package:social_network_flutter/feed/logic/entites/user.dart';

class Comment {
  final int id;
  final String text;
  final User author;
  final int answersCount;
  final int likesCount;
  final bool likedByUser;
  final User? answerToUser;
  final String createdAt;

  Comment({
    required this.id,
    required this.text,
    required this.author,
    required this.likedByUser,
    required this.likesCount,
    required this.answersCount,
    this.answerToUser,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['comment_id'] as int,
      author: User.fromJson(json['user']),
      text: json['content'] as String,
      likedByUser: json['liked_by_user'] as bool,
      answersCount: json['answers_count'] as int,
      likesCount: json['likes_count'] as int,
      answerToUser: json['answer_user'] != null
          ? User.fromJson(json['answer_user'])
          : null,
      createdAt: json['created_at'] as String,
    );
  }
}
