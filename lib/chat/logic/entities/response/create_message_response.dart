import 'package:social_network_flutter/chat_list/logic/entities/message.dart';

class CreateMessageResponse {
  final List<Message> messages;

  CreateMessageResponse({required this.messages});

  factory CreateMessageResponse.fromJson(Map<String, dynamic> json) {
    return CreateMessageResponse(
      messages: (json['messages'] as List)
          .map((e) => Message.fromJson(e))
          .toList(),
    );
  }
}
