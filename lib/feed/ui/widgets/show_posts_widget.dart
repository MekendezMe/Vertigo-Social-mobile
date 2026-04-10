import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/common/framework/ui/toast/custom_toast.dart';
import 'package:social_network_flutter/common/framework/ui/toast/custom_toast_widget.dart';
import 'package:social_network_flutter/feed/logic/bloc/feed_bloc.dart';
import 'package:social_network_flutter/feed/logic/entites/post.dart';
import 'package:social_network_flutter/feed/ui/widgets/create_post_widget.dart';
import 'package:social_network_flutter/feed/ui/widgets/post_item_widget.dart';

class ShowPostsWidget extends StatefulWidget {
  const ShowPostsWidget({
    super.key,
    required this.state,
    required this.onShowGallery,
    required this.feedBloc,
    required this.onShowComments,
  });
  final FeedBloc feedBloc;
  final FeedLoaded state;
  final void Function({
    required BuildContext context,
    required List<String> images,
    required int index,
  })
  onShowGallery;
  final Function({required BuildContext context, required int postId})
  onShowComments;

  @override
  State<ShowPostsWidget> createState() => _ShowPostsWidgetState();
}

class _ShowPostsWidgetState extends State<ShowPostsWidget> {
  late final ScrollController _scrollController;
  Post? _editPost;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return BlocListener<FeedBloc, FeedState>(
      bloc: widget.feedBloc,
      listenWhen: (previous, current) =>
          (previous is FeedLoaded && current is FeedLoaded) &&
          previous.isDeleting != current.isDeleting,
      listener: (context, state) {
        if (state is FeedLoaded) {
          if (state.isDeleteSuccess) {
            CustomToast.show(
              CustomToastWidget(text: "Пост успешно удален"),
              dismissAfter: Duration(milliseconds: 1500),
            );
          }
          if (!state.isDeleting && !state.isDeleteSuccess) {
            CustomToast.show(
              CustomToastWidget(
                text: "Ошибка при удалении поста. Попробуйте еще раз",
              ),
              dismissAfter: Duration(milliseconds: 1500),
            );
          }
        }
      },
      child: CustomScrollView(
        controller: _scrollController,
        physics: state.posts.isEmpty
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: CreatePostWidget(
              state: state,
              feedBloc: widget.feedBloc,
              onPostCreated: () {},
              onShowGallery: widget.onShowGallery,
              post: _editPost,
              onCancelEdit: onCancelEdit,
              onSuccessEdit: onSuccessEdit,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 30)),
          if (state.posts.isEmpty)
            SliverFillRemaining(
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Нет постов',
                  style: context.theme.textTheme.bodyLarge,
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final post = state.posts[index];
                return PostItemWidget(
                  post: post,
                  feedBloc: widget.feedBloc,
                  onLikePressed: () {
                    widget.feedBloc.add(ToggleLike(postId: post.id));
                  },
                  onShowGallery: widget.onShowGallery,
                  onShowComments: widget.onShowComments,
                  user: state.user,
                  onEdit: ({required Post post}) => onEdit(post),
                  onDelete: ({required Post post}) => onDelete(post),
                );
              }, childCount: state.posts.length),
            ),
        ],
      ),
    );
  }

  void onEdit(Post post) {
    setState(() {
      _editPost = post;
    });
  }

  void onSuccessEdit() {
    setState(() {
      _editPost = null;
    });
  }

  void onCancelEdit() {
    setState(() {
      _editPost = null;
    });
  }

  void onDelete(Post post) {
    widget.feedBloc.add(DeletePost(postId: post.id));
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final blocState = context.read<FeedBloc>().state;

    if (blocState is! FeedLoaded || (blocState.isLoadingMore)) {
      return;
    }
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;

    if (current >= max - 200 && !(blocState.isLastPage)) {
      final nextPage = blocState.currentPage + 1;
      context.read<FeedBloc>().add(LoadMorePosts(pageNumber: nextPage));
    }
  }
}
