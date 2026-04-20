import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/navigation/navigation_coordinator.dart';
import 'package:social_network_flutter/helpers/post/media_gallery/show_gallery.dart';
import 'package:social_network_flutter/post/logic/bloc/post_bloc.dart';
import 'package:social_network_flutter/post/logic/bloc/post_composer_bloc.dart';
import 'package:social_network_flutter/post/ui/screens/post_screen.dart';

class PostCoordinator extends NavigationCoordinator {
  final DIContainer diContainer;
  final Widget Function({required int postId}) showCommentScreen;

  PostCoordinator({required this.diContainer, required this.showCommentScreen});

  void onShowPostScreen({required BuildContext context, required int postId}) {
    push(
      context: context,
      rootNavigator: true,
      page: PostScreen(
        postId: postId,
        postBloc: diContainer.resolve<PostBloc>(),
        postComposerBloc: diContainer.resolve<PostComposerBloc>(),
        showCommentScreen: ({required int postId}) =>
            showCommentScreen(postId: postId),
        onShowGallery:
            ({
              required BuildContext context,
              required List<String> media,
              required int index,
            }) => showGallery(context, media, index),
      ),
    );
  }
}
