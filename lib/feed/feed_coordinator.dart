import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/navigation/navigation_coordinator.dart';
import 'package:social_network_flutter/feed/logic/bloc/feed_bloc.dart';
import 'package:social_network_flutter/feed/ui/screens/feed_screen.dart';
import 'package:social_network_flutter/helpers/post/media_gallery/show_gallery.dart';
import 'package:social_network_flutter/post/logic/bloc/post_composer_bloc.dart';

class FeedCoordinator extends NavigationCoordinator {
  final DIContainer diContainer;
  final Function({required BuildContext context}) onShowProfile;
  final Function({required BuildContext context}) onShowSettings;
  final Function({required BuildContext context}) onShowChatList;
  final Function({required BuildContext context, required int postId})
  onShowComments;
  final Function({required BuildContext context, required int postId})
  onShowPost;

  FeedCoordinator({
    required this.diContainer,
    required this.onShowProfile,
    required this.onShowSettings,
    required this.onShowComments,
    required this.onShowPost,
    required this.onShowChatList,
  });

  void onShowMain({required BuildContext context}) {
    pushReplacement(
      context: context,
      page: FeedScreen(
        feedBloc: diContainer.resolve<FeedBloc>(),
        postComposerBloc: diContainer.resolve<PostComposerBloc>(),
        onShowProfile: onShowProfile,
        onShowSettings: onShowSettings,
        onShowChatList: onShowChatList,
        onShowComments: onShowComments,
        onShowPost: onShowPost,
        onShowGallery:
            ({
              required BuildContext context,
              required List<String> media,
              required int index,
            }) => showGallery(context, media, index),
      ),
    );
  }

  Widget showMain() {
    return FeedScreen(
      feedBloc: diContainer.resolve<FeedBloc>(),
      postComposerBloc: diContainer.resolve<PostComposerBloc>(),
      onShowProfile: onShowProfile,
      onShowSettings: onShowSettings,
      onShowChatList: onShowChatList,
      onShowComments: onShowComments,
      onShowPost: onShowPost,
      onShowGallery:
          ({
            required BuildContext context,
            required List<String> media,
            required int index,
          }) => showGallery(context, media, index),
    );
  }
}
