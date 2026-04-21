import 'package:social_network_flutter/common/framework/errors/exceptions/app_exceptions.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:social_network_flutter/common/framework/storages/secure_storage.dart';
import 'package:social_network_flutter/common/launcher/logic/entities/request/logout_request.dart';
import 'package:social_network_flutter/common/launcher/logic/entities/request/save_token_request.dart';
import 'package:social_network_flutter/common/launcher/logic/entities/response/logout_response.dart';
import 'package:social_network_flutter/common/launcher/logic/entities/request/token_request.dart';
import 'package:social_network_flutter/common/launcher/logic/entities/response/save_token_response.dart';
import 'package:social_network_flutter/common/launcher/logic/entities/response/token_response.dart';
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
  Future<TokenResponse> getTokens() async {
    try {
      final refreshToken = secureStorage.refreshToken;
      final deviceId = secureStorage.deviceId;

      if (refreshToken == null || deviceId == null) {
        throw AuthException();
      }

      final request = TokenRequest(
        refreshToken: refreshToken,
        deviceId: deviceId,
      );

      final response = await requestSender.send<TokenResponse>(
        request: request,
        fromJson: (json) => TokenResponse.fromJson(json),
        body: request.toJson(),
      );

      return response;
    } catch (e, st) {
      talker.handle(e, st);
      throw AuthException();
    }
  }

  Future<SaveTokenResponse> saveToken(SaveTokenRequest request) async {
    try {
      final response = await requestSender.send<SaveTokenResponse>(
        request: request,
        fromJson: (json) => SaveTokenResponse.fromJson(json),
        body: request.toJson(),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<LogoutResponse> logout() async {
    try {
      final request = LogoutRequest();

      final response = await requestSender.send<LogoutResponse>(
        request: request,
        fromJson: (json) => LogoutResponse.fromJson(json),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
