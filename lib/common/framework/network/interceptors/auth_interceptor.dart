import 'package:dio/dio.dart';
import 'package:social_network_flutter/common/framework/device/device_info_service.dart';
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
    final deviceId = secureStorage.deviceId;
    final userAgent = await DeviceInfoService.getUserAgent();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    if (deviceId != null) {
      options.headers['Device-ID'] = deviceId;
    }

    options.headers['User-Agent'] = userAgent;

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final path = err.requestOptions.path;

    if (path.contains('/refresh')) {
      handler.next(err);
      return;
    }
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
        final tokens = await launcherRepository.getTokens();

        if (tokens.accessToken.isEmpty || tokens.refreshToken.isEmpty) {
          // logoutHandler.onLogout();
          handler.next(err);
          return;
        }

        tokenService.setToken(tokens.accessToken);
        await secureStorage.load();
        secureStorage.refreshToken = tokens.refreshToken;
        await secureStorage.save();

        final deviceId = secureStorage.deviceId;
        if (deviceId == null || deviceId.isEmpty) {
          // logoutHandler.onLogout();
          handler.next(err);
          return;
        }

        final requestOptions = err.requestOptions;

        requestOptions.headers['Authorization'] =
            'Bearer ${tokens.accessToken}';
        requestOptions.headers['Device-ID'] = secureStorage.deviceId;
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
