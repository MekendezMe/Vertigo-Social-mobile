import 'package:flutter/material.dart';
import 'package:social_network_flutter/chat/logic/bloc/chat_bloc.dart';
import 'package:social_network_flutter/chat/ui/screens/chat_screen.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/navigation/navigation_coordinator.dart';

class ChatCoordinator extends NavigationCoordinator {
  final DIContainer diContainer;

  ChatCoordinator({required this.diContainer});

  void onShowChatScreen({required BuildContext context, required int chatId}) {
    push(
      context: context,
      page: ChatScreen(
        chatId: chatId,
        chatBloc: diContainer.resolve<ChatBloc>(),
      ),
    );
  }
}
