import 'package:social_network_flutter/feed/logic/entites/user.dart';

class Post {
  final int id;
  final User creator;
  final String text;
  final int likesCount;
  final int commentsCount;
  final String createdAt;
  final bool likedByUser;
  final List<String> images;

  Post({
    required this.id,
    required this.creator,
    required this.text,
    required this.images,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
    required this.likedByUser,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['post_id'] as int,
      creator: User.fromJson(json['user']),
      text: json['content'] as String,
      images: (json['images'] as List?)?.cast<String>() ?? [],
      likesCount: json['likes_count'] as int,
      commentsCount: json['comments_count'] as int,
      likedByUser: json['liked_by_user'] as bool,
      createdAt: json['created_at'] as String,
    );
  }

  Post copyWith({
    int? id,
    User? creator,
    String? text,
    int? likesCount,
    int? commentsCount,
    String? createdAt,
    bool? likedByUser,
    List<String>? images,
  }) {
    return Post(
      id: id ?? this.id,
      creator: creator ?? this.creator,
      text: text ?? this.text,
      images: images ?? this.images,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      createdAt: createdAt ?? this.createdAt,
      likedByUser: likedByUser ?? this.likedByUser,
    );
  }
}
