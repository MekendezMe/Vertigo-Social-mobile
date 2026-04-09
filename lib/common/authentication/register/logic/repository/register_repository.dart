import 'package:social_network_flutter/common/authentication/entities/auth_response.dart';
import 'package:social_network_flutter/common/authentication/register/entities/register_request.dart';
import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/framework/errors/exceptions/app_exceptions.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:social_network_flutter/common/framework/storages/secure_storage.dart';
import 'package:social_network_flutter/common/launcher/logic/service/token_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

class RegisterRepository {
  final ISecureStorage secureStorage;
  final Talker talker;
  final RequestSender requestSender;
  final TokenService tokenService;
  final UserService userService;

  RegisterRepository({
    required this.secureStorage,
    required this.talker,
    required this.requestSender,
    required this.tokenService,
    required this.userService,
  });

  Future<AuthResponse> register(RegisterRequest registerRequest) async {
    try {
      final response = await requestSender.send<AuthResponse>(
        request: registerRequest,
        body: registerRequest.toJson(),
        fromJson: (json) => AuthResponse.fromJson(json),
      );
      secureStorage.refreshToken = response.refreshToken;
      secureStorage.deviceId = response.deviceId;
      await secureStorage.save();
      tokenService.setToken(response.accessToken);
      await userService.loadCurrentUser();
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
