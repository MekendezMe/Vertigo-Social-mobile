import 'package:flutter/material.dart';
import 'package:social_network_flutter/comment/logic/bloc/comment_bloc.dart';
import 'package:social_network_flutter/comment/ui/screens/comment_screen.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/navigation/navigation_coordinator.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';

class CommentCoordinator extends NavigationCoordinator {
  final DIContainer diContainer;

  CommentCoordinator({required this.diContainer});

  void onShowCommentScreen({
    required BuildContext context,
    required int postId,
  }) {
    _onShowCommentModal(context, postId);
  }

  void _onShowCommentModal(BuildContext context, postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.color.veryLightGray,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CommentScreen(
        commentBloc: diContainer.resolve<CommentBloc>(),
        postId: postId,
      ),
    );
  }
}
