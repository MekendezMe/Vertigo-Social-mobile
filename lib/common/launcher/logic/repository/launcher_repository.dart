import 'package:social_network_flutter/common/framework/errors/exceptions/connection_exception.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:social_network_flutter/common/framework/storages/secure_storage.dart';
import 'package:social_network_flutter/common/launcher/logic/entities/token_request.dart';
import 'package:social_network_flutter/common/launcher/logic/entities/token_response.dart';
import 'package:talker_flutter/talker_flutter.dart';

class LauncherRepository {
  final ISecureStorage secureStorage;
  final RequestSender requestSender;
  final Talker talker;

  LauncherRepository({
    required this.secureStorage,
    required this.requestSender,
    required this.talker,
  });
  Future<String> getAccessToken() async {
    try {
      final refreshToken = secureStorage.refreshToken;

      if (refreshToken == null) {
        throw AuthException(
          message: "Ошибка авторизации. Необходимо заново авторизоваться",
          code: 401,
        );
      }

      final request = TokenRequest(refreshToken: refreshToken);

      final response = await requestSender.send<TokenResponse>(
        request: request,
        fromJson: (json) => TokenResponse.fromJson(json),
        body: request.toJson(),
      );

      if (response == null) {
        throw AuthException(
          message: "Ошибка авторизации. Необходимо заново авторизоваться",
          code: 401,
        );
      }

      return response.accessToken;
    } catch (e, st) {
      talker.handle(e, st);
      throw AuthException(
        message: "Ошибка авторизации. Необходимо заново авторизоваться",
        code: 401,
      );
    }
  }
}
