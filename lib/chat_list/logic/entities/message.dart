import 'package:social_network_flutter/chat_list/logic/entities/reaction.dart';
import 'package:social_network_flutter/feed/logic/entites/user.dart';
import 'package:social_network_flutter/post/logic/entities/post.dart';

class Message {
  final int id;
  final String? type;
  final String? content;
  final bool isEdited;
  final bool isRead;
  final String createdAt;
  final List<String> media;
  final User? senderUser;
  final User? forwardedFromUser;
  final Message? replyToMessage;
  final Post? post;
  final List<Reaction>? reactions;

  Message({
    required this.id,
    required this.type,
    required this.content,
    required this.isEdited,
    required this.isRead,
    required this.createdAt,
    required this.media,
    required this.senderUser,
    required this.forwardedFromUser,
    required this.replyToMessage,
    required this.post,
    required this.reactions,
  });
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int,
      type: json['type'] as String?,
      content: json['content'] as String?,
      isEdited: json['is_edited'] as bool,
      isRead: json['is_read'] as bool,
      createdAt: json['created_at'] as String,
      media: json['media'] != null
          ? (json['media'] as List).cast<String>()
          : [],
      senderUser: json['sender_user'] != null
          ? User.fromJson(json['sender_user'])
          : null,
      post: json['post'] != null ? Post.fromJson(json['post']) : null,
      forwardedFromUser: json['forwarded_from_user'] != null
          ? User.fromJson(json['forwarded_from_user'])
          : null,
      replyToMessage: json['reply_to_message'] != null
          ? Message.fromJson(json['reply_to_message'])
          : null,
      reactions: json['reactions'] != null
          ? (json['reactions'] as List)
                .map((e) => Reaction.fromJson(e))
                .toList()
          : null,
    );
  }

  Message copyWith({
    int? id,
    String? type,
    String? content,
    bool? isEdited,
    bool? isRead,
    String? createdAt,
    List<String>? media,
    User? senderUser,
    Post? post,
    User? forwardedFromUser,
    Message? replyToMessage,
    List<Reaction>? reactions,
  }) {
    return Message(
      id: id ?? this.id,
      type: type ?? this.type,
      content: content ?? this.content,
      isEdited: isEdited ?? this.isEdited,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      media: media ?? this.media,
      senderUser: senderUser ?? this.senderUser,
      post: post ?? this.post,
      forwardedFromUser: forwardedFromUser ?? this.forwardedFromUser,
      replyToMessage: replyToMessage ?? this.replyToMessage,
      reactions: reactions ?? this.reactions,
    );
  }
}
