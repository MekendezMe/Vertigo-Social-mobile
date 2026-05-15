import 'package:social_network_flutter/chat/logic/entities/request/create_message_request.dart';
import 'package:social_network_flutter/chat/logic/entities/request/get_messages_request.dart';
import 'package:social_network_flutter/chat/logic/entities/response/create_message_response.dart';
import 'package:social_network_flutter/chat/logic/entities/response/get_messages_response.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class ChatRepository {
  final RequestSender requestSender;

  ChatRepository({required this.requestSender});

  Future<GetMessagesResponse> getMessages(GetMessagesRequest request) async {
    try {
      final response = await requestSender.send<GetMessagesResponse>(
        request: request,
        fromJson: (json) => GetMessagesResponse.fromJson(json),
        queryParams: request.queryParamsToJson(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<CreateMessageResponse> createMessage(
    CreateMessageRequest request,
  ) async {
    try {
      final formData = await request.getBody();
      final response = await requestSender.send<CreateMessageResponse>(
        request: request,
        fromJson: (json) => CreateMessageResponse.fromJson(json),
        formData: formData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
