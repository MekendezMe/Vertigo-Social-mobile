import 'package:social_network_flutter/chat_list/logic/entities/chat.dart';

class GetChatsResponse {
  final List<Chat> chats;
  final bool lastPage;

  GetChatsResponse({required this.chats, required this.lastPage});

  factory GetChatsResponse.fromJson(Map<String, dynamic> json) {
    return GetChatsResponse(
      chats: (json['chats'] as List).map((e) => Chat.fromJson(e)).toList(),
      lastPage: json['last_page'],
    );
  }
}
