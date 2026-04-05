import 'package:flutter/material.dart';
import 'package:social_network_flutter/comment/logic/bloc/comment_bloc.dart';
import 'package:social_network_flutter/comment/logic/entities/comment.dart';
import 'package:social_network_flutter/comment/logic/helpers/navigation_type_helper.dart';
import 'package:social_network_flutter/comment/ui/widgets/comment_item_widget.dart';
import 'package:social_network_flutter/comment/ui/widgets/empty_comment_widget.dart';

Widget commentScrollView(
  BuildContext context,
  CommentsLoaded state,
  NavigationItem current,
  ScrollController controller,
  Function({required Comment comment}) onReplyPressed,
  CommentBloc commentBloc,
) {
  bool isEmpty = current.type == NavigationType.comments
      ? state.comments.isEmpty
      : state.answers.isEmpty;
  final key = current.type == NavigationType.comments
      ? "${current.type.name}_${state.post.id}"
      : null;
  return CustomScrollView(
    key: key != null ? PageStorageKey(key) : null,
    controller: controller,
    slivers: [
      if (isEmpty)
        SliverFillRemaining(
          child: emptyCommentWidget("Нет комментариев", context),
        )
      else
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final comment = current.type == NavigationType.comments
                  ? state.comments[index]
                  : state.answers[index];
              return commentItemWidget(
                comment: comment,
                onReplyPressed: current.type == NavigationType.comments
                    ? () => onReplyPressed(comment: comment)
                    : null,
                commentBloc: commentBloc,
                context: context,
                // onLikePressed: () {
                //   commentBloc.add(ToggleLike(postId: post.id));
                // },
              );
            },
            childCount: current.type == NavigationType.comments
                ? state.comments.length
                : state.answers.length,
          ),
        ),
    ],
  );
}
