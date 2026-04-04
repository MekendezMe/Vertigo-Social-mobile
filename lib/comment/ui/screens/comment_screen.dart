import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/comment/ui/widgets/comment_item_widget.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/comment/logic/bloc/comment_bloc.dart';

class CommentBottomSheetScreen extends StatelessWidget {
  const CommentBottomSheetScreen({super.key, required this.commentBloc});
  final CommentBloc commentBloc;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: context.color.veryLightGray,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildDragHandle(context),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Комментарии',
              style: context.theme.textTheme.headlineMedium,
            ),
          ),
          SizedBox(height: 16),
          Divider(color: context.color.darkGray),
          Expanded(
            child: BlocConsumer<CommentBloc, CommentState>(
              bloc: commentBloc,
              listener: (context, state) {},
              builder: (context, state) {
                if (state is CommentsLoadingFailure) {
                  SliverFillRemaining(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Нет комментариев',
                        style: context.theme.textTheme.bodyLarge,
                      ),
                    ),
                  );
                }
                if (state is CommentsLoaded) {
                  return CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final comment = state.comments[index];
                          return commentItemWidget(
                            comment: comment,
                            commentBloc: commentBloc,
                            context: context,
                            // onLikePressed: () {
                            //   commentBloc.add(ToggleLike(postId: post.id));
                            // },
                          );
                        }, childCount: state.comments.length),
                      ),
                    ],
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandle(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
