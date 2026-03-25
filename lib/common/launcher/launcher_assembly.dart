import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/framework/di/di_assembly.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:social_network_flutter/common/framework/storages/preferences_storage.dart';
import 'package:social_network_flutter/common/framework/storages/secure_storage.dart';
import 'package:social_network_flutter/common/launcher/logic/bloc/launcher_bloc.dart';
import 'package:social_network_flutter/common/launcher/logic/repository/launcher_repository.dart';
import 'package:social_network_flutter/common/launcher/logic/service/logout_service.dart';
import 'package:social_network_flutter/common/launcher/logic/service/token_service.dart';
import 'package:social_network_flutter/common/permissions/permission_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

class LauncherAssembly extends DIAssembly {
  @override
  assembly(DIContainer container) {
    container.registerSingleton(
      (container) => LauncherRepository(
        secureStorage: container.resolve<ISecureStorage>(),
        talker: container.resolve<Talker>(),
        requestSender: container.resolve<RequestSender>(),
      ),
    );
    container.registerSingleton(
      (container) => LauncherBloc(
        launcherRepository: container.resolve<LauncherRepository>(),
        preferencesStorage: container.resolve<IPreferencesStorage>(),
        secureStorage: container.resolve<ISecureStorage>(),
        tokenService: container.resolve<TokenService>(),
        talker: container.resolve<Talker>(),
        logoutService: container.resolve<LogoutService>(),
        userService: container.resolve<UserService>(),
        errorHandler: container.resolve<ErrorHandler>(),
        permissionService: container.resolve<PermissionService>(),
      ),
    );
  }
}
