import 'package:social_network_flutter/common/authentication/entities/auth_response.dart';
import 'package:social_network_flutter/common/authentication/login/logic/entities/login_request.dart';
import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/framework/errors/exceptions/app_exceptions.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:social_network_flutter/common/framework/storages/secure_storage.dart';
import 'package:social_network_flutter/common/launcher/logic/service/token_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

class LoginRepository {
  final ISecureStorage secureStorage;
  final Talker talker;
  final RequestSender requestSender;
  final TokenService tokenService;
  final UserService userService;

  LoginRepository({
    required this.secureStorage,
    required this.talker,
    required this.requestSender,
    required this.tokenService,
    required this.userService,
  });

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await requestSender.send<AuthResponse>(
        request: request,
        fromJson: (json) => AuthResponse.fromJson(json),
        body: request.toJson(),
      );

      if (response == null) {
        throw ApiException(message: "Пустой ответ сервера");
      }

      secureStorage.refreshToken = response.refreshToken;
      secureStorage.deviceId = response.deviceId;
      await secureStorage.save();
      tokenService.setToken(response.accessToken);
      await userService.loadCurrentUser();
      return response;
    } catch (e, st) {
      talker.handle(e, st);
      rethrow;
    }
  }
}
