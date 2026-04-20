import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/common/framework/ui/toast/custom_toast.dart';
import 'package:social_network_flutter/common/framework/ui/toast/custom_toast_widget.dart';
import 'package:social_network_flutter/feed/logic/bloc/feed_bloc.dart';
import 'package:social_network_flutter/post/logic/bloc/post_bloc.dart';
import 'package:social_network_flutter/post/logic/bloc/post_composer_bloc.dart';
import 'package:social_network_flutter/post/logic/entities/post.dart';
import 'package:social_network_flutter/ui/app_bar/main_app_bar.dart';
import 'package:social_network_flutter/ui/widgets/custom_circular_progress_indicator.dart';
import 'package:social_network_flutter/ui/widgets/loading/build_loading_failure.dart';
import 'package:social_network_flutter/ui/widgets/post/post_composer_section.dart';
import 'package:social_network_flutter/ui/widgets/post/post_item_widget.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({
    super.key,
    required this.postId,
    required this.postBloc,
    required this.postComposerBloc,
    required this.onShowGallery,
    required this.showCommentScreen,
  });
  final int postId;
  final PostBloc postBloc;
  final PostComposerBloc postComposerBloc;
  final Function({
    required BuildContext context,
    required List<String> media,
    required int index,
  })
  onShowGallery;

  final Widget Function({required int postId}) showCommentScreen;

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  Post? _editPost;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.postBloc.add(LoadPost(postId: widget.postId));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    if (bottom > 0 && _editPost == null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: MultiBlocListener(
        listeners: [
          BlocListener<PostComposerBloc, PostComposerState>(
            bloc: widget.postComposerBloc,
            listenWhen: (previous, current) =>
                previous.isUpdateSuccess != current.isUpdateSuccess ||
                previous.updateError != current.updateError ||
                previous.updatedPost != current.updatedPost ||
                previous.isDeleteSuccess != current.isDeleteSuccess ||
                previous.deleteError != current.deleteError ||
                previous.likedPost != current.likedPost ||
                previous.likeError != current.likeError ||
                previous.subscribedUserId != current.subscribedUserId ||
                previous.subscribeError != current.subscribeError,
            listener: (context, composerState) {
              CustomToast.init(context);
              if (composerState.isUpdateSuccess) {
                CustomToast.show(
                  CustomToastWidget(text: "Пост успешно обновлен"),
                  dismissAfter: const Duration(milliseconds: 1500),
                );
                if (composerState.updatedPost != null) {
                  widget.postBloc.add(
                    PostPatchedLocally(post: composerState.updatedPost!),
                  );
                  context.read<FeedBloc>().add(
                    ReplacePostInFeed(post: composerState.updatedPost!),
                  );
                }
              }
              if (composerState.updateError != null) {
                CustomToast.show(
                  CustomToastWidget(
                    text:
                        "Ошибка ${composerState.updateError} при обновлении поста",
                  ),
                  dismissAfter: const Duration(milliseconds: 1500),
                );
              }
              if (composerState.isDeleteSuccess) {
                CustomToast.show(
                  CustomToastWidget(text: "Пост успешно удален"),
                  dismissAfter: const Duration(milliseconds: 1500),
                );
                context.read<FeedBloc>().add(
                  RemovePostFromFeed(postId: widget.postId),
                );
                Navigator.of(context).pop();
              }
              if (composerState.deleteError != null) {
                CustomToast.show(
                  CustomToastWidget(
                    text: "Ошибка при удалении поста. Попробуйте еще раз",
                  ),
                  dismissAfter: const Duration(milliseconds: 1500),
                );
              }
              if (composerState.likedPost != null &&
                  composerState.likedPost!.id == widget.postId) {
                widget.postBloc.add(
                  PostPatchedLocally(post: composerState.likedPost!),
                );
                context.read<FeedBloc>().add(
                  ReplacePostInFeed(post: composerState.updatedPost!),
                );
              }
              if (composerState.likeError != null) {
                CustomToast.show(
                  CustomToastWidget(text: composerState.likeError!),
                  dismissAfter: const Duration(milliseconds: 1500),
                );
              }
              if (composerState.subscribedUserId != null) {
                final currentState = widget.postBloc.state;
                if (currentState is PostLoaded &&
                    currentState.post.creator.id ==
                        composerState.subscribedUserId) {
                  widget.postBloc.add(
                    PostPatchedLocally(
                      post: currentState.post.copyWith(subscribedByUser: true),
                    ),
                  );
                  context.read<FeedBloc>().add(
                    ReplacePostInFeed(post: composerState.updatedPost!),
                  );
                }
                CustomToast.show(
                  CustomToastWidget(text: "Успешная подписка"),
                  dismissAfter: const Duration(milliseconds: 1500),
                );
              }
              if (composerState.subscribeError != null) {
                CustomToast.show(
                  CustomToastWidget(text: composerState.subscribeError!),
                  dismissAfter: const Duration(milliseconds: 1500),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<PostBloc, PostState>(
          bloc: widget.postBloc,
          builder: (context, state) {
            return BlocBuilder<PostComposerBloc, PostComposerState>(
              bloc: widget.postComposerBloc,
              builder: (context, composerState) {
                if (state is PostLoading) {
                  return Center(
                    child: customCircularProgressIndicator(context: context),
                  );
                }
                if (state is PostLoadingFailure) {
                  return buildLoadingFailure(
                    context: context,
                    onTap: () =>
                        widget.postBloc.add(LoadPost(postId: widget.postId)),
                  );
                }
                if (state is PostLoaded) {
                  return _buildPostScreen(state, composerState);
                }
                return SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPostScreen(PostLoaded state, PostComposerState composerState) {
    bool isEdit = _editPost != null;
    return RefreshIndicator(
      backgroundColor: context.color.darkGray,
      color: context.color.lightPurple,
      onRefresh: () async {
        setState(() {
          _editPost = null;
        });
        final completer = Completer<void>();

        final subscription = widget.postBloc.stream.listen((state) {
          if (state is PostLoaded || state is PostLoadingFailure) {
            completer.complete();
          }
        });

        widget.postBloc.add(LoadPost(postId: widget.postId));

        await completer.future;

        await subscription.cancel();
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Visibility(
              visible: state.user.id == state.post.creator.id && isEdit,
              child: PostComposerSection(
                onShowGallery: widget.onShowGallery,
                post: _editPost,
                onCancelEdit: onCancelEdit,
                onSuccessEdit: onSuccessEdit,
                onCreatePost: null,
                onEditPost: onEditPost,
                onPickImage: onPickImage,
                onPickMedia: onPickMedia,
                onRemoveMediaFromPost: onRemoveMediaFromPost,
                onClearMedia: onClearMedia,
                user: state.user,
                media: composerState.media,
                isCreating:
                    composerState.isCreating || composerState.isUpdating,
                isSuccessCreate: composerState.isCreateSuccess,
                isSuccessUpdate: composerState.isUpdateSuccess,
                createError: composerState.createError,
                updateError: composerState.updateError,
              ),
            ),
            PostItemWidget(
              post: state.post,
              onLikePressed: () => onLike(state.post),
              onShowGallery: widget.onShowGallery,
              onShowComments: null,
              user: state.user,
              onEdit: ({required Post post}) => onEditing(post),
              onDelete: ({required Post post}) => onDelete(post),
              onSubscribe: ({required Post post}) => onSubscribe(post),
            ),
            SizedBox(height: 20),
            widget.showCommentScreen(postId: state.post.id),
          ],
        ),
      ),
    );
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
      _editPost = post;
    });
  }

  void onSuccessEdit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _editPost = null;
        });
      }
    });
  }

  void onCancelEdit() {
    setState(() {
      _editPost = null;
    });
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
