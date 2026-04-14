import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/navigation/navigation_coordinator.dart';
import 'package:social_network_flutter/feed/logic/bloc/feed_bloc.dart';
import 'package:social_network_flutter/feed/ui/screens/feed_screen.dart';
import 'package:social_network_flutter/feed/ui/widgets/modal_gallery_widget.dart';

class FeedCoordinator extends NavigationCoordinator {
  final DIContainer diContainer;
  final Function({required BuildContext context}) onShowProfile;
  final Function({required BuildContext context}) onShowSettings;
  final Function({required BuildContext context, required int postId})
  onShowComments;

  FeedCoordinator({
    required this.diContainer,
    required this.onShowProfile,
    required this.onShowSettings,
    required this.onShowComments,
  });

  // void onShowMain({required BuildContext context}) {
  //   pushReplacement(
  //     context: context,
  //     page: FeedScreen(
  //       feedBloc: diContainer.resolve<FeedBloc>(),
  //       logoutHandler: diContainer.resolve<ILogoutHandler>(),
  //       onShowProfile: onShowProfile,
  //       onShowSettings: onShowSettings,
  //       onShowGallery:
  //           ({
  //             required BuildContext context,
  //             required List<String> images,
  //             required int index,
  //           }) => _showGallery(context, images, index),
  //     ),
  //   );
  // }

  Widget showMain() {
    return FeedScreen(
      feedBloc: diContainer.resolve<FeedBloc>(),
      onShowProfile: onShowProfile,
      onShowSettings: onShowSettings,
      onShowComments: onShowComments,
      onShowGallery:
          ({
            required BuildContext context,
            required List<String> media,
            required int index,
          }) => _showGallery(context, media, index),
    );
  }

  void _showGallery(
    BuildContext context,
    List<String> media,
    int initialIndex,
  ) {
    showDialog(
      context: context,
      builder: (context) =>
          ModalGallery(media: media, initialIndex: initialIndex),
    );
  }
}
