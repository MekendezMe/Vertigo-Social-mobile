import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:social_network_flutter/feed/logic/entites/request/user/subscribe_request.dart';
import 'package:social_network_flutter/feed/logic/entites/response/user/subscribe_response.dart';
import 'package:talker_flutter/talker_flutter.dart';

class FeedRepository {
  final RequestSender requestSender;
  final Talker talker;

  FeedRepository({required this.requestSender, required this.talker});

  Future<SubscribeResponse> subscribeToUser(SubscribeRequest request) async {
    final response = await requestSender.send(
      request: request,
      fromJson: (json) => SubscribeResponse.fromJson(json),
    );
    return response;
  }
}
