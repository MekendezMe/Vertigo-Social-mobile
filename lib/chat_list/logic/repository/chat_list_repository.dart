import 'package:social_network_flutter/chat_list/logic/entities/request/get_chats_request.dart';
import 'package:social_network_flutter/chat_list/logic/entities/response/get_chats_response.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class ChatListRepository {
  final RequestSender requestSender;

  ChatListRepository({required this.requestSender});

  Future<GetChatsResponse> getChats(GetChatsRequest request) async {
    try {
      final response = await requestSender.send(
        queryParams: request.queryParamsToJson(),
        request: request,
        fromJson: (json) => GetChatsResponse.fromJson(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
