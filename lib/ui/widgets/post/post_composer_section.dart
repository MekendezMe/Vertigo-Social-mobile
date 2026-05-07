import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_network_flutter/feed/logic/entites/user.dart';
import 'package:social_network_flutter/ui/widgets/post/create_post_widget.dart';
import 'package:social_network_flutter/post/logic/entities/post.dart';

class PostComposerSection extends StatelessWidget {
  const PostComposerSection({
    super.key,
    required this.onShowGallery,
    required this.user,
    required this.isCreating,
    required this.onEditPost,
    required this.onCancelEdit,
    required this.onSuccessEdit,
    required this.onPickImage,
    required this.onPickMedia,
    required this.onRemoveMediaFromPost,
    required this.onClearMedia,
    this.post,
    this.onCreatePost,
    this.media,
    this.isSuccessCreate = false,
    this.isSuccessUpdate = false,
    this.createError,
    this.updateError,
  });

  final void Function({
    required BuildContext context,
    required List<String> media,
    required int index,
  })
  onShowGallery;
  final User user;
  final bool isCreating;
  final Post? post;
  final List<File>? media;
  final bool isSuccessCreate;
  final bool isSuccessUpdate;
  final String? createError;
  final String? updateError;
  final void Function({required String text, required List<File> media})?
  onCreatePost;
  final void Function({
    required int postId,
    required String text,
    required List<File> media,
    required List<String> deletedImages,
  })
  onEditPost;
  final void Function() onCancelEdit;
  final void Function() onSuccessEdit;
  final void Function() onPickImage;
  final void Function() onPickMedia;
  final void Function({required int index}) onRemoveMediaFromPost;
  final void Function() onClearMedia;

  @override
  Widget build(BuildContext context) {
    return CreatePostWidget(
      onShowGallery: onShowGallery,
      post: post,
      media: media,
      user: user,
      isCreating: isCreating,
      onCreatePost: onCreatePost,
      onEditPost: onEditPost,
      onCancelEdit: onCancelEdit,
      onSuccessEdit: onSuccessEdit,
      onPickImage: onPickImage,
      onPickMedia: onPickMedia,
      onClearMedia: onClearMedia,
      onRemoveMediaFromPost: onRemoveMediaFromPost,
      isSuccessCreate: isSuccessCreate,
      isSuccessUpdate: isSuccessUpdate,
      createError: createError,
      updateError: updateError,
    );
  }
}
