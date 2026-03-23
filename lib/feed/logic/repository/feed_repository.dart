import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:talker_flutter/talker_flutter.dart';

class FeedRepository {
  final RequestSender requestSender;
  final Talker talker;

  FeedRepository({required this.requestSender, required this.talker});
}
