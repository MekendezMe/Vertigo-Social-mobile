import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/feed/logic/bloc/feed_bloc.dart';
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
  final Function({required BuildContext context}) onShowComments;

  @override
  State<ShowPostsWidget> createState() => _ShowPostsWidgetState();
}

class _ShowPostsWidgetState extends State<ShowPostsWidget> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return CustomScrollView(
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
              return postItemWidget(
                post: post,
                feedBloc: widget.feedBloc,
                context: context,
                onLikePressed: () {
                  widget.feedBloc.add(ToggleLike(postId: post.id));
                },
                onShowGallery: widget.onShowGallery,
                onShowComments: widget.onShowComments,
              );
            }, childCount: state.posts.length),
          ),
      ],
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final blocState = context.read<FeedBloc>().state;

    if (blocState is! FeedLoaded || (blocState.isLoadingMore ?? false)) {
      return;
    }
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;

    if (current >= max - 200 && !(blocState.isLastPage ?? false)) {
      final nextPage = blocState.currentPage + 1;
      context.read<FeedBloc>().add(LoadMorePosts(pageNumber: nextPage));
    }
  }
}
