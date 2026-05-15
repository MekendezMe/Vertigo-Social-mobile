import 'package:social_network_flutter/chat_list/logic/entities/chat.dart';
import 'package:social_network_flutter/chat_list/logic/entities/message.dart';

class GetMessagesResponse {
  final List<Message> messages;
  final bool lastPage;
  final Chat chat;
  final int? pageNumber;
  GetMessagesResponse({
    required this.messages,
    required this.lastPage,
    required this.chat,
    required this.pageNumber,
  });

  factory GetMessagesResponse.fromJson(Map<String, dynamic> json) {
    return GetMessagesResponse(
      messages: (json['messages'] as List)
          .map((e) => Message.fromJson(e))
          .toList(),
      lastPage: json['last_page'] as bool,
      chat: Chat.fromJson(json['chat']),
      pageNumber: json['page_number'] as int?,
    );
  }
}
