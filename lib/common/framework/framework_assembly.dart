import 'package:dio/dio.dart';
import 'package:social_network_flutter/common/framework/di/di_assembly.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/environment/environment.dart';
import 'package:social_network_flutter/common/framework/network/dio.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:social_network_flutter/common/framework/storages/preferences_storage.dart';
import 'package:social_network_flutter/common/framework/storages/secure_storage.dart';
import 'package:social_network_flutter/common/launcher/logic/service/token_service.dart';
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
  }
}
