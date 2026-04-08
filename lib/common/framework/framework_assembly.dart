import 'package:dio/dio.dart';
import 'package:social_network_flutter/common/framework/di/di_assembly.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/environment/environment.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/common/framework/media/media_service.dart';
import 'package:social_network_flutter/common/framework/network/dio.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:social_network_flutter/common/framework/storages/preferences_storage.dart';
import 'package:social_network_flutter/common/framework/storages/secure_storage.dart';
import 'package:social_network_flutter/common/launcher/launcher_dependencies.dart';
import 'package:social_network_flutter/common/launcher/logic/service/logout_service.dart';
import 'package:social_network_flutter/common/launcher/logic/service/token_service.dart';
import 'package:social_network_flutter/common/framework/notifications/notification_service.dart';
import 'package:social_network_flutter/common/framework/permissions/permission_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

class FrameworkAssembly extends DIAssembly {
  @override
  assembly(DIContainer container) {
    container.registerSingleton<IPreferencesStorage>(
      (container) => PreferencesStorage(),
    );
    container.registerSingleton<ISecureStorage>((container) => SecureStorage());
    container.registerSingleton((container) => Talker());
    container.registerSingleton((container) => TokenService());
    container.registerSingleton(
      (container) => PermissionService(
        preferencesStorage: container.resolve<IPreferencesStorage>(),
      ),
    );
    container.registerSingleton<INotificationService>(
      (container) => NotificationService(),
    );
    container.registerSingleton(
      (container) => MediaService(
        permissionService: container.resolve<PermissionService>(),
      ),
    );
    container.registerSingleton<Dio>(
      (container) => getDio(
        talker: container.resolve<Talker>(),
        environment: container.resolve<Environment>(),
      ),
    );
    container.registerSingleton<RequestSender>(
      (container) => RequestSender(
        talker: container.resolve<Talker>(),
        tokenService: container.resolve<TokenService>(),
        secureStorage: container.resolve<ISecureStorage>(),
        dio: container.resolve<Dio>(),
      ),
    );
    container.registerSingleton((container) => LogoutService());
    container.registerSingleton<ILogoutHandler>(
      (container) =>
          LogoutHandler(logoutService: container.resolve<LogoutService>()),
    );
    container.registerSingleton(
      (container) =>
          ErrorHandler(logoutHandler: container.resolve<ILogoutHandler>()),
    );
  }
}
