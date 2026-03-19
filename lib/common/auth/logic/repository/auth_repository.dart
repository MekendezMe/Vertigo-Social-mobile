import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:social_network_flutter/common/framework/storages/secure_storage.dart';
import 'package:talker_flutter/talker_flutter.dart';

class AuthRepository {
  final ISecureStorage secureStorage;
  final Talker talker;
  final RequestSender requestSender;

  AuthRepository({
    required this.secureStorage,
    required this.talker,
    required this.requestSender,
  });

  Future<RegisterResponse?>
}
