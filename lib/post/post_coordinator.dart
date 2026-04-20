import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/navigation/navigation_coordinator.dart';
import 'package:social_network_flutter/helpers/post/media_gallery/show_gallery.dart';
import 'package:social_network_flutter/post/logic/bloc/post_bloc.dart';
import 'package:social_network_flutter/post/ui/screens/post_screen.dart';

class PostCoordinator extends NavigationCoordinator {
  final DIContainer diContainer;

  PostCoordinator({required this.diContainer});

  void onShowPostScreen({required BuildContext context, required int postId}) {
    push(
      context: context,
      rootNavigator: true,
      page: PostScreen(
        postId: postId,
        postBloc: diContainer.resolve<PostBloc>(),
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
