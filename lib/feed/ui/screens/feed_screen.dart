import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/common/framework/ui/toast/custom_toast.dart';
import 'package:social_network_flutter/common/framework/ui/toast/custom_toast_widget.dart';
import 'package:social_network_flutter/feed/logic/bloc/feed_bloc.dart';
import 'package:social_network_flutter/post/logic/entities/post.dart';
import 'package:social_network_flutter/post/logic/bloc/post_composer_bloc.dart';
import 'package:social_network_flutter/feed/ui/widgets/show_posts_widget.dart';
import 'package:social_network_flutter/ui/app_bar/main_app_bar.dart';
import 'package:social_network_flutter/ui/widgets/post/post_composer_section.dart';
import 'package:social_network_flutter/ui/widgets/custom_circular_progress_indicator.dart';
import 'package:social_network_flutter/ui/widgets/drawer/custom_drawer.dart';
import 'package:social_network_flutter/ui/widgets/loading/build_loading_failure.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({
    super.key,
    required this.feedBloc,
    required this.postComposerBloc,
    required this.onShowProfile,
    required this.onShowSettings,
    required this.onShowGallery,
    required this.onShowComments,
    required this.onShowPost,
    required this.onShowChatList,
  });
  final FeedBloc feedBloc;
  final PostComposerBloc postComposerBloc;
  final Function({required BuildContext context}) onShowProfile;
  final Function({required BuildContext context}) onShowSettings;
  final Function({required BuildContext context, required int postId})
  onShowComments;
  final Function({required BuildContext context, required int postId})
  onShowPost;
  final Function({required BuildContext context}) onShowChatList;
  final Function({
    required BuildContext context,
    required List<String> media,
    required int index,
  })
  onShowGallery;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Post? _editPost;
  @override
  void initState() {
    super.initState();
    widget.feedBloc.add(LoadFeed());
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
          onShowChatList: () => widget.onShowChatList(context: context),
          onShowMain: null,
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<PostComposerBloc, PostComposerState>(
            bloc: widget.postComposerBloc,
            listenWhen: (previous, current) =>
                previous.isCreateSuccess != current.isCreateSuccess ||
                previous.isUpdateSuccess != current.isUpdateSuccess ||
                previous.isDeleteSuccess != current.isDeleteSuccess ||
                previous.createdPost != current.createdPost ||
                previous.updatedPost != current.updatedPost ||
                previous.deletedPostId != current.deletedPostId ||
                previous.createError != current.createError ||
                previous.updateError != current.updateError ||
                previous.deleteError != current.deleteError ||
                previous.likedPost != current.likedPost ||
                previous.likeError != current.likeError ||
                previous.subscribedUserId != current.subscribedUserId ||
                previous.subscribeError != current.subscribeError,
            listener: (context, state) {
              CustomToast.init(context);
              if (state.isCreateSuccess) {
                CustomToast.show(
                  CustomToastWidget(text: "Пост успешно создан"),
                  dismissAfter: const Duration(milliseconds: 1500),
                );
                if (state.createdPost != null) {
                  widget.feedBloc.add(AddPostToTop(post: state.createdPost!));
                }
              }
              if (state.createError != null) {
                // CustomToast.show(
                //   CustomToastWidget(
                //     text: "Ошибка ${state.createError} при создании поста",
                //   ),
                //   dismissAfter: const Duration(milliseconds: 1500),
                // );
              }
              if (state.isUpdateSuccess) {
                CustomToast.show(
                  CustomToastWidget(text: "Пост успешно обновлен"),
                  dismissAfter: const Duration(milliseconds: 1500),
                );
                if (state.updatedPost != null) {
                  widget.feedBloc.add(
                    ReplacePostInFeed(post: state.updatedPost!),
                  );
                }
              }
              if (state.updateError != null) {
                // CustomToast.show(
                //   CustomToastWidget(
                //     text: "Ошибка ${state.updateError} при обновлении поста",
                //   ),
                //   dismissAfter: const Duration(milliseconds: 1500),
                // );
              }
              if (state.isDeleteSuccess) {
                CustomToast.show(
                  CustomToastWidget(text: "Пост успешно удален"),
                  dismissAfter: const Duration(milliseconds: 1500),
                );
                if (state.deletedPostId != null) {
                  widget.feedBloc.add(
                    RemovePostFromFeed(postId: state.deletedPostId!),
                  );
                }
              }
              if (state.deleteError != null) {
                // CustomToast.show(
                //   CustomToastWidget(
                //     text: "Ошибка при удалении поста. Попробуйте еще раз",
                //   ),
                //   dismissAfter: const Duration(milliseconds: 1500),
                // );
              }
              if (state.likedPost != null) {
                widget.feedBloc.add(ReplacePostInFeed(post: state.likedPost!));
              }
              if (state.likeError != null) {
                CustomToast.show(
                  CustomToastWidget(text: state.likeError!),
                  dismissAfter: const Duration(milliseconds: 1500),
                );
              }
              if (state.subscribedUserId != null) {
                widget.feedBloc.add(
                  MarkUserSubscribedInFeed(userId: state.subscribedUserId!),
                );
                CustomToast.show(
                  CustomToastWidget(text: "Успешная подписка"),
                  dismissAfter: const Duration(milliseconds: 1500),
                );
              }
              if (state.subscribeError != null) {
                // CustomToast.show(
                //   CustomToastWidget(text: state.subscribeError!),
                //   dismissAfter: const Duration(milliseconds: 1500),
                // );
              }
            },
          ),
        ],
        child: BlocBuilder<FeedBloc, FeedState>(
          bloc: widget.feedBloc,
          builder: (context, state) {
            return BlocBuilder<PostComposerBloc, PostComposerState>(
              bloc: widget.postComposerBloc,
              builder: (context, composerState) {
                final composerState = widget.postComposerBloc.state;
                if (state is FeedLoading) {
                  return Center(
                    child: customCircularProgressIndicator(context: context),
                  );
                }
                if (state is FeedLoadingFailure) {
                  return buildLoadingFailure(
                    error: state.error?.toString(),
                    context: context,
                    onTap: () => widget.feedBloc.add(LoadFeed()),
                  );
                }

                if (state is FeedLoaded) {
                  return _buildFeedContent(state, composerState);
                }
                return SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeedContent(FeedLoaded state, PostComposerState composerState) {
    return Column(
      children: [
        PostComposerSection(
          onShowGallery: widget.onShowGallery,
          post: _editPost,
          media: composerState.media,
          user: state.user,
          isCreating: composerState.isCreating || composerState.isUpdating,
          onCreatePost: onCreatePost,
          onEditPost: onEditPost,
          onCancelEdit: onCancelEdit,
          onSuccessEdit: onSuccessEdit,
          onPickImage: onPickImage,
          onPickMedia: onPickMedia,
          onClearMedia: onClearMedia,
          onRemoveMediaFromPost: onRemoveMediaFromPost,
          isSuccessCreate: composerState.isCreateSuccess,
          isSuccessUpdate: composerState.isUpdateSuccess,
          createError: composerState.createError,
          updateError: composerState.updateError,
        ),
        SizedBox(height: 10),
        Expanded(
          child: RefreshIndicator(
            backgroundColor: context.color.darkGray,
            color: context.color.lightPurple,
            onRefresh: () async {
              final completer = Completer<void>();

              final subscription = widget.feedBloc.stream.listen((state) {
                if (state is FeedLoaded || state is FeedLoadingFailure) {
                  completer.complete();
                }
              });

              widget.feedBloc.add(LoadFeed());

              await completer.future;

              await subscription.cancel();
            },
            child: ShowPostsWidget(
              state: state,
              feedBloc: widget.feedBloc,
              onShowGallery: widget.onShowGallery,
              onShowComments: widget.onShowComments,
              onShowPost:
                  ({required BuildContext context, required int postId}) =>
                      onShowPost(context, postId),
              onEdit: ({required Post post}) => onEditing(post),
              onDelete: ({required Post post}) => onDelete(post),
              onSubscribe: ({required Post post}) => onSubscribe(post),
              onLike: ({required Post post}) => onLike(post),
            ),
          ),
        ),
      ],
    );
  }

  void clearPost() {
    setState(() {
      _editPost = null;
    });
  }

  void onShowPost(BuildContext context, int postId) {
    clearPost();
    onClearMedia();
    widget.onShowPost(context: context, postId: postId);
  }

  void onClearMedia() {
    widget.postComposerBloc.add(ClearMediaRequested());
  }

  void onPickMedia() {
    widget.postComposerBloc.add(PickMediaFromGalleryRequested());
  }

  void onPickImage() {
    widget.postComposerBloc.add(PickImageFromCameraRequested());
  }

  void onRemoveMediaFromPost({required int index}) {
    widget.postComposerBloc.add(RemoveMediaRequested(index: index));
  }

  void onCreatePost({required String text, required List<File> media}) {
    widget.postComposerBloc.add(CreatePostRequested(text: text, media: media));
  }

  void onEditPost({
    required int postId,
    required String text,
    required List<File> media,
    required List<String> deletedImages,
  }) {
    widget.postComposerBloc.add(
      EditPostRequested(
        postId: postId,
        text: text,
        media: media,
        deletedImages: deletedImages,
      ),
    );
  }

  void onEditing(Post post) {
    setState(() {
      widget.postComposerBloc.add(ClearMediaRequested());
      _editPost = post;
    });
  }

  void onSuccessEdit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        clearPost();
      }
    });
  }

  void onCancelEdit() {
    clearPost();
  }

  void onDelete(Post post) {
    widget.postComposerBloc.add(DeletePostRequested(postId: post.id));
  }

  void onSubscribe(Post post) {
    widget.postComposerBloc.add(Subscribe(userId: post.creator.id));
  }

  void onLike(Post post) {
    widget.postComposerBloc.add(ToggleLike(post: post));
  }
}
