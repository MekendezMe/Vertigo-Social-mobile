import 'package:flutter/material.dart';
import 'package:social_network_flutter/chat_list/logic/bloc/chat_list_bloc.dart';
import 'package:social_network_flutter/chat_list/ui/screens/chat_list_screen.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/navigation/navigation_coordinator.dart';

class ChatListCoordinator extends NavigationCoordinator {
  final DIContainer diContainer;
  final Function({required BuildContext context}) onShowProfile;
  final Function({required BuildContext context}) onShowSettings;
  final Function({required BuildContext context}) onShowMain;
  final Function({required BuildContext context, required int chatId})
  onShowChat;
  ChatListCoordinator({
    required this.diContainer,
    required this.onShowProfile,
    required this.onShowSettings,
    required this.onShowMain,
    required this.onShowChat,
  });

  void onShowChatListScreen({required BuildContext context}) {
    pushReplacement(
      context: context,
      page: ChatListScreen(
        chatListBloc: diContainer.resolve<ChatListBloc>(),
        onShowMain: onShowMain,
        onShowProfile: onShowProfile,
        onShowSettings: onShowSettings,
        onShowChat: onShowChat,
      ),
    );
  }
}
