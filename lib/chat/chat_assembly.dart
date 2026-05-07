import 'package:social_network_flutter/chat/logic/bloc/chat_bloc.dart';
import 'package:social_network_flutter/chat/logic/repository/chat_repository.dart';
import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/framework/di/di_assembly.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ChatAssembly extends DIAssembly {
  @override
  assembly(DIContainer container) {
    container.registerSingleton(
      (container) =>
          ChatRepository(requestSender: container.resolve<RequestSender>()),
    );
    container.registerSingleton(
      (container) => ChatBloc(
        talker: container.resolve<Talker>(),
        chatRepository: container.resolve<ChatRepository>(),
        errorHandler: container.resolve<ErrorHandler>(),
        userService: container.resolve<UserService>(),
      ),
    );
  }
}
