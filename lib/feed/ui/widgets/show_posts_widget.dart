import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/common/framework/ui/toast/custom_toast.dart';
import 'package:social_network_flutter/common/framework/ui/toast/custom_toast_widget.dart';
import 'package:social_network_flutter/feed/logic/bloc/feed_bloc.dart';
import 'package:social_network_flutter/feed/logic/entites/post.dart';
import 'package:social_network_flutter/feed/logic/entites/post_types.dart';
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
    required List<String> media,
    required int index,
  })
  onShowGallery;
  final Function({required BuildContext context, required int postId})
  onShowComments;

  @override
  State<ShowPostsWidget> createState() => _ShowPostsWidgetState();
}

class _ShowPostsWidgetState extends State<ShowPostsWidget>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  PostType _currentType = PostType.all;
  late final TabController _tabController;
  Post? _editPost;
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
    return BlocListener<FeedBloc, FeedState>(
      bloc: widget.feedBloc,
      listenWhen: (previous, current) =>
          (previous is FeedLoaded && current is FeedLoaded) &&
          ((previous.isDeleting != current.isDeleting) ||
              current.isSuccessSubscribed),
      listener: (context, state) {
        if (state is FeedLoaded) {
          if (state.isSuccessSubscribed) {
            CustomToast.show(
              CustomToastWidget(text: "Успешная подписка"),
              dismissAfter: Duration(milliseconds: 1500),
            );
          }
          if (state.isDeleteSuccess) {
            CustomToast.show(
              CustomToastWidget(text: "Пост успешно удален"),
              dismissAfter: Duration(milliseconds: 1500),
            );
          }
          if (!state.isDeleting &&
              !state.isDeleteSuccess &&
              !state.isSuccessSubscribed) {
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
          SliverToBoxAdapter(child: SizedBox(height: 10)),
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
                      tabs: [
                        Tab(
                          child: Text(
                            "Все",
                            style: _currentType == PostType.all
                                ? context.theme.textTheme.bodyLarge
                                : context.theme.textTheme.bodyLarge!.modify(
                                    color: context.color.veryDarkGray
                                        .withOpacity(0.8),
                                  ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Рекомендованное",
                            style: _currentType == PostType.recommended
                                ? context.theme.textTheme.bodyLarge
                                : context.theme.textTheme.bodyLarge!.modify(
                                    color: context.color.veryDarkGray
                                        .withOpacity(0.8),
                                  ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Подписки",
                            style: _currentType == PostType.subscribe
                                ? context.theme.textTheme.bodyLarge
                                : context.theme.textTheme.bodyLarge!.modify(
                                    color: context.color.veryDarkGray
                                        .withOpacity(0.8),
                                  ),
                          ),
                        ),
                      ],
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
                  onSubscribe: ({required Post post}) => onSubscribe(post),
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
    _animateScroll(toStart: true);
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

  void onSubscribe(Post post) {
    widget.feedBloc.add(Subscribe(userId: post.creator.id));
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
