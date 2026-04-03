import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/common/launcher/launcher_dependencies.dart';
import 'package:social_network_flutter/feed/logic/bloc/feed_bloc.dart';
import 'package:social_network_flutter/feed/ui/widgets/base_container_widget.dart';
import 'package:social_network_flutter/feed/ui/widgets/post_item_widget.dart';
import 'package:social_network_flutter/ui/app_bar/main_app_bar.dart';
import 'package:social_network_flutter/ui/widgets/button/main_button.dart';
import 'package:social_network_flutter/ui/widgets/custom_circular_progress_indicator.dart';
import 'package:social_network_flutter/ui/widgets/drawer/custom_drawer.dart';
import 'package:social_network_flutter/ui/widgets/text_field/main_text_field.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({
    super.key,
    required this.feedBloc,
    required this.onShowProfile,
    required this.onShowSettings,
    required this.onShowGallery,
    required this.logoutHandler,
  });
  final FeedBloc feedBloc;
  final ILogoutHandler logoutHandler;
  final Function({required BuildContext context}) onShowProfile;
  final Function({required BuildContext context}) onShowSettings;
  final Function({
    required BuildContext context,
    required List<String> images,
    required int index,
  })
  onShowGallery;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late final ScrollController _scrollController;
  TextEditingController inputController = TextEditingController();
  bool isInputError = false;
  int _pageNumber = 1;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    widget.feedBloc.add(LoadFeed(pageNumber: _pageNumber));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      drawer: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: customDrawer(
          context: context,
          active: TypeScreen.feed,
          onShowSettings: () => widget.onShowSettings(context: context),
          onShowProfile: () => widget.onShowProfile(context: context),
          onShowFeed: null,
        ),
      ),
      body: BlocConsumer<FeedBloc, FeedState>(
        bloc: widget.feedBloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is FeedLoading) {
            return Center(
              child: customCircularProgressIndicator(context: context),
            );
          }
          if (state is FeedLoaded) {
            return RefreshIndicator(
              backgroundColor: context.color.darkGray,
              color: context.color.lightPurple,
              onRefresh: () async {
                final completer = Completer<void>();

                final subscription = widget.feedBloc.stream.listen((state) {
                  if (state is FeedLoaded || state is FeedLoadingFailure) {
                    completer.complete();
                  }
                });

                widget.feedBloc.add(LoadFeed(pageNumber: _pageNumber));

                await completer.future;

                await subscription.cancel();
              },
              child: _showPostsWidget(
                state,
                inputController,
                widget.onShowGallery,
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _showPostsWidget(
    FeedLoaded state,
    TextEditingController controller,
    void Function({
      required BuildContext context,
      required List<String> images,
      required int index,
    })
    onShowGallery,
  ) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(child: _createPostWidget(state, controller)),
        SliverToBoxAdapter(child: SizedBox(height: 30)),
        SliverToBoxAdapter(
          child: ElevatedButton(
            onPressed: () => widget.logoutHandler.onLogout(),
            child: Text("Выйти"),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final post = state.posts[index];
            return postItemWidget(
              post: post,
              context: context,
              onLikePressed: () {
                widget.feedBloc.add(ToggleLike(postId: post.id));
              },
              onShowGallery: onShowGallery,
            );
          }, childCount: state.posts.length),
        ),
      ],
    );
  }

  Widget _createPostWidget(FeedLoaded state, TextEditingController controller) {
    final avatarUrl = state.user.avatar;
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;
    return baseContainerWidget(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 14, top: 10),
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: hasAvatar
                        ? Image.network(
                            avatarUrl,
                            width: 45,
                            height: 45,
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        child: mainTextField(
                          context: context,
                          controller: controller,
                          style: context.theme.textTheme.bodyLarge!,
                          hintText: "Что у вас нового?",
                          radius: 24,
                          onChanged: onChanged,
                          isInputError: isInputError,
                        ),
                      ),
                      SizedBox(height: 18),
                      _buildImageGrid(state.images ?? []),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14),
          Divider(color: context.color.gray, thickness: 0.8),
          SizedBox(height: 25),
          Row(
            children: [
              Row(
                children: [
                  IconButton(
                    iconSize: 25,
                    onPressed: () {
                      widget.feedBloc.add(PickImageFromCamera());
                    },
                    icon: Icon(Icons.photo),
                    color: context.color.gray,
                  ),
                  IconButton(
                    iconSize: 25,
                    onPressed: () {
                      widget.feedBloc.add(PickImagesFromGallery());
                    },
                    icon: Icon(Icons.attach_file),
                    color: context.color.gray,
                  ),
                  IconButton(
                    iconSize: 25,
                    onPressed: () {},
                    icon: Icon(Icons.emoji_emotions),
                    color: context.color.gray,
                  ),
                ],
              ),
              Spacer(),
              Container(
                height: 55,
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: mainButton(
                  backgroundColor: context.color.dimPurple.withOpacity(0.8),
                  context: context,
                  child: state.isCreating
                      ? Center(
                          child: customCircularProgressIndicator(
                            context: context,
                          ),
                        )
                      : Text(
                          "Опубликовать",
                          style: context.theme.textTheme.bodyMedium,
                        ),
                  onTap: () => _onCreatePost(state.user.id, state.images ?? []),
                  radius: 14,
                ),
              ),
            ],
          ),
        ],
      ),
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
      _pageNumber += 1;
      context.read<FeedBloc>().add(LoadMorePosts(pageNumber: _pageNumber));
    }
  }

  Widget _buildImageGrid(List<File> images) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            images[index],
            fit: BoxFit.cover,
            width: 30,
            height: 30,
          ),
        );
      },
    );
  }

  void onChanged(String value) {
    setState(() {
      isInputError = false;
    });
  }

  void _onCreatePost(int userId, List<File> images) {
    if (inputController.text.isEmpty && images.isEmpty) {
      setState(() {
        isInputError = true;
      });
      return;
    }
    widget.feedBloc.add(CreatePost(text: inputController.text, images: images));
    setState(() {
      inputController.text = "";
    });
  }
}
