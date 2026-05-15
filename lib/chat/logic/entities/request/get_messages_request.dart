import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class GetMessagesRequest extends IRequest {
  final int chatId;
  final int pageNumber;
  // final int lastReadMessageId;
  GetMessagesRequest({
    required this.chatId,
    required this.pageNumber,
    // required this.lastReadMessageId,
  });
  @override
  String get method => "chats/$chatId/messages";

  @override
  HttpMethod get httpMethod => HttpMethod.get;

  Map<String, dynamic> queryParamsToJson() {
    return {"page_number": pageNumber}; // TODO: ласт рид месседж еще
  }
}
