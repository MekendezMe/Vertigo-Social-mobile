import 'package:social_network_flutter/feed/logic/entites/user.dart';

class Post {
  final User creator;
  final String text;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;
  final bool likeByUser;

  Post({
    required this.creator,
    required this.text,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
    required this.likeByUser,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      creator: User.fromJson(json['creator']),
      text: json['text'] as String,
      likesCount: json['likes_count'] as int,
      commentsCount: json['comments_count'] as int,
      likeByUser: json['like_by_user'] as bool,
      createdAt: json['created_at'] as DateTime,
    );
  }
}
