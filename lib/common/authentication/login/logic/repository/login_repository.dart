import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:social_network_flutter/common/framework/storages/secure_storage.dart';
import 'package:social_network_flutter/common/launcher/logic/service/token_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

class LoginRepository {
  final ISecureStorage secureStorage;
  final Talker talker;
  final RequestSender requestSender;
  final TokenService tokenService;

  LoginRepository({
    required this.secureStorage,
    required this.talker,
    required this.requestSender,
    required this.tokenService,
  });
}
