import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/feed/logic/bloc/feed_bloc.dart';
import 'package:social_network_flutter/post/logic/entities/post.dart';
import 'package:social_network_flutter/post/logic/entities/post_types.dart';
import 'package:social_network_flutter/feed/ui/widgets/build_tabs.dart';
import 'package:social_network_flutter/ui/widgets/post/post_item_widget.dart';

class ShowPostsWidget extends StatefulWidget {
  const ShowPostsWidget({
    super.key,
    required this.state,
    required this.onShowGallery,
    required this.feedBloc,
    required this.onShowComments,
    required this.onEdit,
    required this.onDelete,
    required this.onSubscribe,
    required this.onLike,
    required this.onShowPost,
  });
  final FeedBloc feedBloc;
  final FeedLoaded state;
  final void Function({
    required BuildContext context,
    required List<String> media,
    required int index,
  })
  onShowGallery;
  final Function({required BuildContext context, required int postId})
  onShowComments;
  final Function({required BuildContext context, required int postId})
  onShowPost;

  final Function({required Post post}) onEdit;
  final Function({required Post post}) onDelete;
  final Function({required Post post}) onSubscribe;
  final Function({required Post post}) onLike;

  @override
  State<ShowPostsWidget> createState() => _ShowPostsWidgetState();
}

class _ShowPostsWidgetState extends State<ShowPostsWidget>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  PostType _currentType = PostType.all;
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentType = PostType.values[_tabController.index];
        });
        widget.feedBloc.add(ChangeFeedType(type: _currentType));
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          child: DefaultTabController(
            length: 3,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabBar(
                    controller: _tabController,
                    dividerHeight: 0.4,
                    dividerColor: Colors.grey[300],
                    indicator: const BoxDecoration(),
                    labelStyle: context.theme.textTheme.bodyLarge!.modify(
                      fontWeight: FontWeight.bold,
                      color: context.color.veryDarkGray,
                    ),
                    unselectedLabelStyle: context.theme.textTheme.bodyLarge,
                    isScrollable: true,
                    tabAlignment: TabAlignment.center,
                    padding: EdgeInsets.all(4),
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: WidgetStatePropertyAll(Colors.transparent),
                    tabs: buildTabs(context, _currentType),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (state.posts.isEmpty)
          SliverFillRemaining(
            child: Container(
              padding: EdgeInsets.only(top: 14),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Нет постов',
                  style: context.theme.textTheme.headlineLarge,
                ),
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final post = state.posts[index];
              return GestureDetector(
                onTap: () =>
                    widget.onShowPost(context: context, postId: post.id),
                child: PostItemWidget(
                  post: post,
                  onLikePressed: () => widget.onLike(post: post),
                  onShowGallery: widget.onShowGallery,
                  onShowComments: widget.onShowComments,
                  user: state.user,
                  onEdit: ({required Post post}) => onEdit(post),
                  onDelete: widget.onDelete,
                  onSubscribe: widget.onSubscribe,
                ),
              );
            }, childCount: state.posts.length),
          ),
      ],
    );
  }

  void onEdit(Post post) {
    widget.onEdit(post: post);
    _animateScroll(toStart: true);
  }

  void _animateScroll({bool toStart = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          toStart ? 0 : _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final blocState = context.read<FeedBloc>().state;

    if (blocState is! FeedLoaded || blocState.isLoadingMore) {
      return;
    }
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;

    if (current >= max - 200 && !(blocState.isLastPage)) {
      final nextPage = blocState.currentPage + 1;
      context.read<FeedBloc>().add(
        LoadMorePosts(pageNumber: nextPage, type: _currentType),
      );
    }
  }
}
