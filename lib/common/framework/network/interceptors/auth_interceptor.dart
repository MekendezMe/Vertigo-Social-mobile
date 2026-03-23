import 'package:dio/dio.dart';
import 'package:social_network_flutter/common/framework/storages/secure_storage.dart';
import 'package:social_network_flutter/common/launcher/logic/repository/launcher_repository.dart';
import 'package:social_network_flutter/common/launcher/logic/service/token_service.dart';

class AuthInterceptor extends Interceptor {
  final TokenService tokenService;
  final ISecureStorage secureStorage;
  final Future<Response> Function(RequestOptions) retry;
  final LauncherRepository launcherRepository;
  // final ILogoutHandler logoutHandler;

  AuthInterceptor({
    required this.tokenService,
    required this.secureStorage,
    required this.retry,
    required this.launcherRepository,
    // required this.logoutHandler,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = tokenService.accessToken;

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (err.requestOptions.extra['isRetry'] == true) {
        // logoutHandler.onLogout();
        handler.next(err);
        return;
      }
      final refreshToken = secureStorage.refreshToken;

      if (refreshToken == null) {
        // logoutHandler.onLogout();
        handler.next(err);
        return;
      }

      try {
        final newToken = await launcherRepository.getAccessToken();

        if (newToken.isEmpty) {
          // logoutHandler.onLogout();
          handler.next(err);
          return;
        }

        tokenService.setToken(newToken);
        final deviceId = secureStorage.deviceId;
        if (deviceId == null || deviceId.isEmpty) {
          // logoutHandler.onLogout();
          handler.next(err);
          return;
        }

        final requestOptions = err.requestOptions;

        requestOptions.headers['Authorization'] = 'Bearer $newToken';
        requestOptions.extra['isRetry'] = true;

        final response = await retry(requestOptions);

        handler.resolve(response);
        return;
      } catch (e) {
        handler.next(err);
        return;
      }
    }

    handler.next(err);
  }
}
