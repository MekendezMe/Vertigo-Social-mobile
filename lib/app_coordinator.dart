import 'package:flutter/material.dart';
import 'package:social_network_flutter/chat/chat_coordinator.dart';
import 'package:social_network_flutter/chat_list/chat_list_coordinator.dart';
import 'package:social_network_flutter/comment/comment_coordinator.dart';
import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/navigation/navigation_service.dart';
import 'package:social_network_flutter/feed/feed_coordinator.dart';
import 'package:social_network_flutter/post/post_coordinator.dart';

class AppCoordinator {
  AppCoordinator({required this.diContainer});

  final DIContainer diContainer;

  void onNotificationTap({
    required BuildContext context,
    required String payload,
  }) {
    final trimmed = payload.trim();
    if (trimmed.isEmpty) return;

    final parts = trimmed.split(':');
    final type = parts[0];

    switch (type) {
      case 'post':
        final postId = int.parse(parts[1]);
        postCoordinator.onShowPostScreen(context: context, postId: postId);
        break;

      case 'comment':
        final postId = int.parse(parts[1]);
        commentCoordinator.onShowCommentScreen(
          context: context,
          postId: postId,
        );
        break;
    }
  }

  late final FeedCoordinator mainCoordinator = FeedCoordinator(
    diContainer: diContainer,
    onShowProfile: ({required context}) => {},
    onShowSettings: ({required context}) => {},
    onShowChatList: ({required context}) => showChatList(context: context),
    onShowComments: ({required context, required postId}) => commentCoordinator
        .onShowCommentScreen(context: context, postId: postId),
    onShowPost: ({required context, required postId}) =>
        postCoordinator.onShowPostScreen(context: context, postId: postId),
  );

  late final ChatListCoordinator chatListCoordinator = ChatListCoordinator(
    diContainer: diContainer,
    onShowProfile: ({required context}) => {},
    onShowSettings: ({required context}) => {},
    onShowMain: ({required context}) => showMain(context: context),
    onShowChat: ({required context, required chatId}) =>
        chatCoordinator.onShowChatScreen(context: context, chatId: chatId),
  );

  late final CommentCoordinator commentCoordinator = CommentCoordinator(
    diContainer: diContainer,
  );

  late final PostCoordinator postCoordinator = PostCoordinator(
    diContainer: diContainer,
    showCommentScreen: ({required postId}) =>
        commentCoordinator.showCommentScreen(postId: postId),
  );

  late final ChatCoordinator chatCoordinator = ChatCoordinator(
    diContainer: diContainer,
  );

  void showMain({required BuildContext context}) {
    mainCoordinator.onShowMain(context: context);
  }

  void showChatList({required BuildContext context}) {
    chatListCoordinator.onShowChatListScreen(context: context);
  }

  Widget getMain() {
    return mainCoordinator.showMain();
  }
}
