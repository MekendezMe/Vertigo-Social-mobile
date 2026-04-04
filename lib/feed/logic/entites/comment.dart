import 'package:social_network_flutter/feed/logic/entites/user.dart';

class Comment {
  final String text;
  final User author;
  final int answersCount;
  final int likesCount;
  final bool likedByUser;
  final String createdAt;

  Comment({
    required this.text,
    required this.author,
    required this.likedByUser,
    required this.likesCount,
    required this.answersCount,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      author: User.fromJson(json['user']),
      text: json['content'] as String,
      likedByUser: json['liked_by_user'] as bool,
      answersCount: json['answers_count'] as int,
      likesCount: json['likes_count'] as int,
      createdAt: json['created_at'] as String,
    );
  }
}
