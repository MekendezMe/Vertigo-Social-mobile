import 'package:social_network_flutter/feed/logic/entites/user.dart';

class Comment {
  final String text;
  final User author;
  // final Comment answers;
  // final int answersCount;
  final int likesCount;
  final DateTime createdAt;

  Comment({
    required this.text,
    required this.author,
    // required this.answers,
    // required this.answersCount,
    required this.likesCount,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      author: User.fromJson(json['author']),
      text: json['text'] as String,
      likesCount: json['likes_count'] as int,
      createdAt: json['created_at'] as DateTime,
    );
  }
}
