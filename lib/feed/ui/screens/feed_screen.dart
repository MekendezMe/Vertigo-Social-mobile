import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/common/framework/ui/toast/custom_toast.dart';
import 'package:social_network_flutter/common/framework/ui/toast/custom_toast_widget.dart';
import 'package:social_network_flutter/feed/logic/bloc/feed_bloc.dart';
import 'package:social_network_flutter/post/logic/entities/post.dart';
import 'package:social_network_flutter/feed/ui/widgets/create_post_widget.dart';
import 'package:social_network_flutter/feed/ui/widgets/show_posts_widget.dart';
import 'package:social_network_flutter/ui/app_bar/main_app_bar.dart';
import 'package:social_network_flutter/ui/widgets/custom_circular_progress_indicator.dart';
import 'package:social_network_flutter/ui/widgets/drawer/custom_drawer.dart';
import 'package:social_network_flutter/ui/widgets/loading/build_loading_failure.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({
    super.key,
    required this.feedBloc,
    required this.onShowProfile,
    required this.onShowSettings,
    required this.onShowGallery,
    required this.onShowComments,
    required this.onShowPost,
  });
  final FeedBloc feedBloc;
  final Function({required BuildContext context}) onShowProfile;
  final Function({required BuildContext context}) onShowSettings;
  final Function({required BuildContext context, required int postId})
  onShowComments;
  final Function({required BuildContext context, required int postId})
  onShowPost;
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
  bool _isSuccessCreate = false;
  bool _isSuccessUpdate = false;
  String? _createError;
  String? _updateError;
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
          onShowFeed: null,
        ),
      ),
      body: BlocConsumer<FeedBloc, FeedState>(
        bloc: widget.feedBloc,
        listener: (context, state) {
          CustomToast.init(context);
          if (state is FeedLoaded) {
            if (state.isCreateSuccess) {
              CustomToast.show(
                CustomToastWidget(text: "Пост успешно создан"),
                dismissAfter: const Duration(milliseconds: 1500),
              );
              setState(() {
                _isSuccessCreate = true;
                _updateError = null;
              });
            }
            if (state.createError != null) {
              CustomToast.show(
                CustomToastWidget(
                  text: "Ошибка ${state.createError} при создании поста",
                ),
                dismissAfter: const Duration(milliseconds: 1500),
              );
              setState(() {
                _isSuccessCreate = false;
                _createError = state.createError;
              });
            }

            if (state.isUpdateSuccess) {
              CustomToast.show(
                CustomToastWidget(text: "Пост успешно обновлен"),
                dismissAfter: const Duration(milliseconds: 1500),
              );
              setState(() {
                _isSuccessUpdate = true;
                _updateError = null;
              });
            }

            if (state.updateError != null) {
              CustomToast.show(
                CustomToastWidget(
                  text: "Ошибка ${state.updateError} при обновлении поста",
                ),
                dismissAfter: Duration(milliseconds: 1500),
              );
              setState(() {
                _isSuccessUpdate = false;
                _updateError = state.updateError;
              });
            }
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
            if (state.deleteError != null) {
              CustomToast.show(
                CustomToastWidget(
                  text: "Ошибка при удалении поста. Попробуйте еще раз",
                ),
                dismissAfter: Duration(milliseconds: 1500),
              );
            }
          }
        },
        builder: (context, state) {
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
            return _buildFeedContent(state);
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFeedContent(FeedLoaded state) {
    return Column(
      children: [
        CreatePostWidget(
          onShowGallery: widget.onShowGallery,
          post: _editPost,
          media: state.media,
          user: state.user,
          isCreating: state.isCreating,
          onCreatePost: onCreatePost,
          onEditPost: onEditPost,
          onCancelEdit: onCancelEdit,
          onSuccessEdit: onSuccessEdit,
          onPickImage: onPickImage,
          onPickMedia: onPickMedia,
          onClearMedia: onClearMedia,
          onRemoveMediaFromPost: onRemoveMediaFromPost,
          isSuccessCreate: _isSuccessCreate,
          isSuccessUpdate: _isSuccessUpdate,
          createError: _createError,
          updateError: _updateError,
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
              onShowPost: widget.onShowPost,
              onEdit: ({required Post post}) => onEditing(post),
              onDelete: ({required Post post}) => onDelete(post),
              onSubscribe: ({required Post post}) => onSubscribe(post),
            ),
          ),
        ),
      ],
    );
  }

  void onClearMedia() {
    widget.feedBloc.add(ClearMedia());
  }

  void onPickMedia() {
    widget.feedBloc.add(PickMediaFromGallery());
  }

  void onPickImage() {
    widget.feedBloc.add(PickImageFromCamera());
  }

  void onRemoveMediaFromPost({required int index}) {
    widget.feedBloc.add(RemoveMediaFromPost(index: index));
  }

  void onCreatePost({required String text, required List<File> media}) {
    widget.feedBloc.add(CreatePost(text: text, media: media));
  }

  void onEditPost({
    required int postId,
    required String text,
    required List<File> media,
    required List<String> deletedImages,
  }) {
    widget.feedBloc.add(
      EditPost(
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
    widget.feedBloc.add(DeletePost(postId: post.id));
  }

  void onSubscribe(Post post) {
    widget.feedBloc.add(Subscribe(userId: post.creator.id));
  }
}
