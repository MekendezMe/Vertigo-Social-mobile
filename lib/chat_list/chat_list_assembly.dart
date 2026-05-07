import 'package:social_network_flutter/chat_list/logic/bloc/chat_list_bloc.dart';
import 'package:social_network_flutter/chat_list/logic/repository/chat_list_repository.dart';
import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/framework/di/di_assembly.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ChatListAssembly extends DIAssembly {
  @override
  assembly(DIContainer container) {
    container.registerSingleton(
      (container) =>
          ChatListRepository(requestSender: container.resolve<RequestSender>()),
    );
    container.registerSingleton(
      (container) => ChatListBloc(
        talker: container.resolve<Talker>(),
        chatListRepository: container.resolve<ChatListRepository>(),
        errorHandler: container.resolve<ErrorHandler>(),
        userService: container.resolve<UserService>(),
      ),
    );
  }
}
