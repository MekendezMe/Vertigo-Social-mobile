import 'package:social_network_flutter/common/authentication/user/repository/user_repository.dart';
import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/framework/di/di_assembly.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:talker_flutter/talker_flutter.dart';

class UserAssembly extends DIAssembly {
  @override
  assembly(DIContainer container) {
    container.registerSingleton(
      (container) => UserRepository(
        requestSender: container.resolve<RequestSender>(),
        talker: container.resolve<Talker>(),
      ),
    );
    container.registerSingleton(
      (container) =>
          UserService(userRepository: container.resolve<UserRepository>()),
    );
  }
}
