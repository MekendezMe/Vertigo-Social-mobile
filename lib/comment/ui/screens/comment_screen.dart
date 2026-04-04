import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/comment/ui/widgets/comment_item_widget.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/comment/logic/bloc/comment_bloc.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({
    super.key,
    required this.commentBloc,
    required this.postId,
  });
  final CommentBloc commentBloc;
  final int postId;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_onScroll);
    widget.commentBloc.add(LoadComments(postId: widget.postId));
    super.initState();
  }

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
              bloc: widget.commentBloc,
              listener: (context, state) {},
              builder: (context, state) {
                if (state is CommentsLoadingFailure) {
                  emptyCommentWidget();
                }
                if (state is CommentsLoaded) {
                  return CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      if (state.comments.isEmpty)
                        emptyCommentWidget()
                      else
                        SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final comment = state.comments[index];
                            return commentItemWidget(
                              comment: comment,
                              commentBloc: widget.commentBloc,
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

  Widget emptyCommentWidget() {
    return SliverFillRemaining(
      child: Align(
        alignment: Alignment.topCenter,
        child: Text(
          'Нет комментариев',
          style: context.theme.textTheme.bodyLarge,
        ),
      ),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final blocState = context.read<CommentBloc>().state;

    if (blocState is! CommentsLoaded || (blocState.isLoadingMore ?? false)) {
      return;
    }
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;

    if (current >= max - 200 && !(blocState.isLastPage)) {
      final nextPage = blocState.currentPage + 1;
      context.read<CommentBloc>().add(
        LoadMoreComments(pageNumber: nextPage, postId: blocState.post.id),
      );
    }
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
