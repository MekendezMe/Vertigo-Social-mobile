import 'package:social_network_flutter/common/authentication/register/logic/bloc/register_bloc.dart';
import 'package:social_network_flutter/common/authentication/register/logic/repository/register_repository.dart';
import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/framework/di/di_assembly.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:social_network_flutter/common/framework/storages/secure_storage.dart';
import 'package:social_network_flutter/common/launcher/logic/service/token_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

class RegisterAssembly extends DIAssembly {
  @override
  assembly(DIContainer container) {
    container.registerSingleton(
      (container) => RegisterRepository(
        secureStorage: container.resolve<ISecureStorage>(),
        talker: container.resolve<Talker>(),
        requestSender: container.resolve<RequestSender>(),
        tokenService: container.resolve<TokenService>(),
        userService: container.resolve<UserService>(),
      ),
    );

    container.registerSingleton(
      (container) => RegisterBloc(
        registerRepository: container.resolve<RegisterRepository>(),
        talker: container.resolve<Talker>(),
        errorHandler: container.resolve<ErrorHandler>(),
      ),
    );
  }
}
