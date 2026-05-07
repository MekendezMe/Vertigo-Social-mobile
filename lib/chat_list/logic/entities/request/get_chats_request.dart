import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class GetChatsRequest extends IRequest {
  final int pageNumber;

  GetChatsRequest({required this.pageNumber});
  @override
  String get method => 'chats';
  @override
  HttpMethod get httpMethod => HttpMethod.get;

  Map<String, dynamic> queryParamsToJson() {
    return {"page_number": pageNumber};
  }
}
