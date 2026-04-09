import 'package:flutter/material.dart';
import 'package:social_network_flutter/comment/logic/bloc/comment_bloc.dart';
import 'package:social_network_flutter/comment/logic/entities/comment.dart';
import 'package:social_network_flutter/comment/logic/helpers/navigation_type_helper.dart';
import 'package:social_network_flutter/comment/ui/widgets/comment_item_widget.dart';
import 'package:social_network_flutter/comment/ui/widgets/empty_comment_widget.dart';

class CommentScrollViewWidget extends StatelessWidget {
  const CommentScrollViewWidget({
    super.key,
    required this.state,
    required this.current,
    required this.controller,
    required this.onReplyPressed,
    required this.commentBloc,
    required this.onAnswerPressed,
    required this.onLikePressed,
  });
  final CommentsLoaded state;
  final NavigationItem current;
  final ScrollController controller;
  final Function({required Comment comment}) onReplyPressed;
  final CommentBloc commentBloc;
  final Function({required Comment comment}) onAnswerPressed;
  final Function({required Comment comment}) onLikePressed;

  @override
  Widget build(BuildContext context) {
    bool isEmpty = current.type == NavigationType.comments
        ? state.comments.isEmpty
        : state.answers.isEmpty;
    final key = current.type == NavigationType.comments
        ? "${current.type.name}_${state.post.id}"
        : null;
    final isComment = current.type == NavigationType.comments;
    return CustomScrollView(
      key: key != null ? PageStorageKey(key) : null,
      controller: controller,
      slivers: [
        if (isEmpty)
          SliverFillRemaining(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: emptyCommentWidget("Нет комментариев", context),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final comment = isComment
                    ? state.comments[index]
                    : state.answers[index];
                return commentItemWidget(
                  comment: comment,
                  onReplyPressed: isComment
                      ? () => onReplyPressed(comment: comment)
                      : null,
                  commentBloc: commentBloc,
                  context: context,
                  onAnswerPressed: onAnswerPressed,
                  onLikePressed: onLikePressed,
                );
              },
              childCount: isComment
                  ? state.comments.length
                  : state.answers.length,
            ),
          ),
      ],
    );
  }
}
