import 'package:dio/dio.dart';
import 'package:social_network_flutter/common/framework/di/di_assembly.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/network/interceptors/auth_interceptor.dart';
import 'package:social_network_flutter/common/framework/storages/secure_storage.dart';
import 'package:social_network_flutter/common/launcher/logic/repository/launcher_repository.dart';
import 'package:social_network_flutter/common/launcher/logic/service/token_service.dart';

class AuthInterceptorAssembly extends DIAssembly {
  @override
  assembly(DIContainer container) {
    final dio = container.resolve<Dio>();

    Future<Response> retry(RequestOptions requestOptions) {
      return dio.fetch(requestOptions);
    }

    final authInterceptor = AuthInterceptor(
      tokenService: container.resolve<TokenService>(),
      secureStorage: container.resolve<ISecureStorage>(),
      retry: retry,
      launcherRepository: container.resolve<LauncherRepository>(),
    );
    dio.interceptors.add(authInterceptor);
  }
}
