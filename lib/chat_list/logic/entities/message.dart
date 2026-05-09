import 'package:social_network_flutter/feed/logic/entites/user.dart';

class Message {
  final int id;
  final String type;
  final Object content;
  final bool isEdited;
  final bool isDeleted;
  final String createdAt;
  final List<String> media;
  final User? senderUser;
  final Message? forwarderMessage;
  final Message? replyToMessage;
  final bool isRead;

  Message({
    required this.id,
    required this.type,
    required this.content,
    required this.isEdited,
    required this.isDeleted,
    required this.createdAt,
    required this.media,
    required this.senderUser,
    required this.forwarderMessage,
    required this.replyToMessage,
    required this.isRead,
  });
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int,
      type: json['type'] as String,
      content: json['content'] as Object,
      isEdited: json['is_edited'] as bool,
      isDeleted: json['is_deleted'] as bool,
      isRead: json['is_read'] as bool,
      createdAt: json['created_at'] as String,
      media: json['media'] != null && json['media'] is List
          ? (json['media'] as List).cast<String>()
          : [],
      senderUser: json['sender_user'] != null
          ? User.fromJson(json['sender_user'])
          : null,
      forwarderMessage: json['forwarder_message'] != null
          ? Message.fromJson(json['forwarder_message'])
          : null,
      replyToMessage: json['reply_to_message'] != null
          ? Message.fromJson(json['reply_to_message'])
          : null,
    );
  }

  Message copyWith({
    int? id,
    String? type,
    Object? content,
    bool? isEdited,
    bool? isDeleted,
    bool? isRead,
    String? createdAt,
    List<String>? media,
    User? senderUser,
    User? forwarderFromUser,
    Message? forwarderMessage,
    Message? replyToMessage,
  }) {
    return Message(
      id: id ?? this.id,
      type: type ?? this.type,
      content: content ?? this.content,
      isEdited: isEdited ?? this.isEdited,
      isDeleted: isDeleted ?? this.isDeleted,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      media: media ?? this.media,
      senderUser: senderUser ?? this.senderUser,
      forwarderMessage: forwarderMessage ?? this.forwarderMessage,
      replyToMessage: replyToMessage ?? this.replyToMessage,
    );
  }
}
