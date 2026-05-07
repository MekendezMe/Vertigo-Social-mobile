import 'package:social_network_flutter/chat_list/logic/entities/message.dart';
import 'package:social_network_flutter/feed/logic/entites/user.dart';

class Chat {
  final int id;
  final String type;
  final String? title;
  final String? avatar;
  final int countParticipants;
  final int countMedia;
  final int countMessages;
  final int countUrls;
  final User? user;
  final Message? lastMessage;
  final Message? lastReadMessage;

  Chat({
    required this.id,
    required this.type,
    required this.title,
    required this.avatar,
    required this.countParticipants,
    required this.countMedia,
    required this.countMessages,
    required this.countUrls,
    required this.user,
    required this.lastMessage,
    required this.lastReadMessage,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] as int,
      type: json['type'] as String,
      title: json['title'] as String?,
      avatar: json['avatar'] as String?,
      countParticipants: json['count_participants'] as int,
      countMedia: json['count_media'] as int,
      countMessages: json['count_messages'] as int,
      countUrls: json['count_url'] as int,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      lastMessage: json['last_message'] != null
          ? Message.fromJson(json['last_message'])
          : null,
      lastReadMessage: json['last_read_message'] != null
          ? Message.fromJson(json['last_read_message'])
          : null,
    );
  }

  Chat copyWith({
    int? id,
    String? type,
    String? title,
    String? avatar,
    int? countParticipants,
    int? countMedia,
    int? countMessages,
    int? countUrls,
    User? user,
    Message? lastMessage,
    Message? lastReadMessage,
  }) {
    return Chat(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      avatar: avatar ?? this.avatar,
      countParticipants: countParticipants ?? this.countParticipants,
      countMedia: countMedia ?? this.countMedia,
      countMessages: countMessages ?? this.countMessages,
      countUrls: countUrls ?? this.countUrls,
      user: user ?? this.user,
      lastMessage: lastMessage ?? this.lastMessage,
      lastReadMessage: lastReadMessage ?? this.lastReadMessage,
    );
  }
}
