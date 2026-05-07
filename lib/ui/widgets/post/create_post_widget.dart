import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/common/launcher/logic/bloc/launcher_bloc.dart';
import 'package:social_network_flutter/feed/logic/entites/user.dart';
import 'package:social_network_flutter/post/logic/entities/post.dart';
import 'package:social_network_flutter/feed/ui/widgets/base_container_widget.dart';
import 'package:social_network_flutter/feed/ui/widgets/button_media_widget.dart';
import 'package:social_network_flutter/feed/ui/widgets/media_grid_widget.dart';
import 'package:social_network_flutter/ui/widgets/avatar/build_avatar.dart';
import 'package:social_network_flutter/ui/widgets/button/main_button.dart';
import 'package:social_network_flutter/ui/widgets/custom_circular_progress_indicator.dart';
import 'package:social_network_flutter/ui/widgets/text_field/main_text_field.dart';

class CreatePostWidget extends StatefulWidget {
  const CreatePostWidget({
    super.key,
    required this.onShowGallery,
    this.post,
    required this.onCancelEdit,
    required this.onSuccessEdit,
    required this.onCreatePost,
    required this.onEditPost,
    required this.onPickImage,
    required this.onPickMedia,
    required this.onRemoveMediaFromPost,
    required this.onClearMedia,
    this.isSuccessCreate = false,
    this.isSuccessUpdate = false,
    this.createError,
    this.updateError,
    this.media,
    required this.user,
    required this.isCreating,
  });
  final void Function({
    required BuildContext context,
    required List<String> media,
    required int index,
  })
  onShowGallery;
  final Post? post;
  final Function({required String text, required List<File> media})?
  onCreatePost;
  final Function({
    required int postId,
    required String text,
    required List<File> media,
    required List<String> deletedImages,
  })
  onEditPost;
  final Function() onCancelEdit;
  final Function() onSuccessEdit;
  final void Function() onClearMedia;
  final void Function() onPickImage;
  final void Function() onPickMedia;
  final void Function({required int index}) onRemoveMediaFromPost;
  final bool isSuccessCreate;
  final bool isSuccessUpdate;
  final String? createError;
  final String? updateError;
  final List<File>? media;
  final User user;
  final bool isCreating;
  @override
  State<CreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showEmojiPicker = false;
  bool _isInputError = false;
  List<String> _deletedUrlMedia = [];
  List<String> _urlMedia = [];
  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {
      _isInputError = false;
    });
  }

  void _onCreatePost(List<File> media) {
    if (_controller.text.isEmpty && media.isEmpty) {
      setState(() {
        _isInputError = true;
      });
      return;
    }
    setState(() {
      _isInputError = false;
      _showEmojiPicker = false;
    });

    if (widget.onCreatePost != null) {
      widget.onCreatePost!(text: _controller.text, media: media);
    }
  }

  void _onUpdatePost(List<File> media, int postId) {
    if (_controller.text.isEmpty && media.isEmpty && _urlMedia.isEmpty) {
      setState(() {
        _isInputError = true;
      });
      return;
    }
    setState(() {
      _isInputError = false;
    });

    widget.onEditPost(
      postId: postId,
      text: _controller.text,
      media: media,
      deletedImages: _deletedUrlMedia,
    );
  }

  void afterCreate() {
    setState(() {
      _controller.clear();
    });
    _focusNode.unfocus();
  }

  void afterUpdate() {
    setState(() {
      _controller.clear();
      _urlMedia.clear();
      _deletedUrlMedia.clear();
    });
    _focusNode.unfocus();
    widget.onSuccessEdit();
  }

  @override
  void initState() {
    super.initState();
    _initFromPost();
  }

  void _initFromPost() {
    if (widget.post != null) {
      _controller.text = widget.post!.text;
      _urlMedia = List.from(widget.post!.media);
      _deletedUrlMedia = [];
    } else {
      _controller.clear();
      _urlMedia = [];
      _deletedUrlMedia = [];
      widget.onClearMedia();
    }
  }

  @override
  void didUpdateWidget(covariant CreatePostWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.post != oldWidget.post) {
      _initFromPost();
    }

    if (widget.createError != null &&
        widget.createError != oldWidget.createError) {
      _isInputError = false;
    }
    if (widget.updateError != null &&
        widget.updateError != oldWidget.updateError) {
      _isInputError = false;
    }

    if (widget.isSuccessCreate && !oldWidget.isSuccessCreate) {
      afterCreate();
      widget.onClearMedia();
    }
    if (widget.isSuccessUpdate && !oldWidget.isSuccessUpdate) {
      afterUpdate();
      widget.onClearMedia();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.post != null;
    final currentMedia = widget.media ?? [];
    final avatarUrl = widget.user.avatar;
    final buttonCreateText = isEdit ? "Обновить" : "Опубликовать";
    return BaseContainerWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 6, top: 10),
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: buildAvatar(context, widget.user.username, avatarUrl),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        constraints: BoxConstraints(maxHeight: 120),
                        child: mainTextField(
                          context: context,
                          controller: _controller,
                          style: context.theme.textTheme.bodyLarge!,
                          hintText: "Поделитесь мыслью...",
                          radius: 24,
                          onChanged: _onChanged,
                          isInputError: _isInputError,
                          focusNode: _focusNode,
                          maxLines: null,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  style: IconButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    highlightColor: Colors.transparent,
                    overlayColor: Colors.transparent,
                  ),
                  iconSize: 25,
                  onPressed: () {
                    setState(() {
                      _showEmojiPicker = !_showEmojiPicker;
                    });
                  },
                  icon: Icon(Icons.emoji_emotions),
                  color: context.color.gray,
                ),
              ],
            ),
          ),
          if (_showEmojiPicker) ...[
            SizedBox(height: 20),
            SizedBox(
              child: EmojiPicker(
                onEmojiSelected: (emoji, category) {
                  setState(() {
                    _controller.text += category.emoji;
                  });
                },
                onBackspacePressed: () => setState(() {
                  final text = _controller.text;
                  if (text.isNotEmpty) {
                    final newText = text.characters.skipLast(1).toString();
                    _controller.text = newText;
                    _controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: newText.length),
                    );
                  }
                }),
              ),
            ),
          ],
          SizedBox(height: 18),
          MediaGridWidget(
            mediaFiles: currentMedia,
            urlMedia: _urlMedia,
            onShowGallery: widget.onShowGallery,
            onDeleteMedia: ({required bool isExisting, required int index}) =>
                onDeleteMedia(isExisting, index),
          ),
          Divider(color: context.color.gray, thickness: 0.8),
          SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ButtonMediaWidget(
                onPickImagePressed: onPickImagePressed,
                onPickMediaPressed: onPickMediaPressed,
              ),
              Spacer(),
              Column(
                children: [
                  AnimatedContainer(
                    constraints: BoxConstraints(minWidth: 170),
                    duration: Duration(milliseconds: 300),
                    height: 55,
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: mainButton(
                      backgroundColor: context.color.dimPurple,
                      context: context,
                      child: widget.isCreating
                          ? Center(
                              child: customCircularProgressIndicator(
                                context: context,
                              ),
                            )
                          : Text(
                              buttonCreateText,
                              style: context.theme.textTheme.bodySmall,
                            ),
                      onTap: isEdit
                          ? () => _onUpdatePost(currentMedia, widget.post!.id)
                          : () => _onCreatePost(currentMedia),
                      radius: 14,
                    ),
                  ),
                  if (isEdit) ...[
                    SizedBox(height: 8),
                    Container(
                      constraints: BoxConstraints(minWidth: 170),
                      height: 55,
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: mainButton(
                        backgroundColor: context.color.red.withOpacity(0.2),
                        context: context,
                        onTap: () {
                          setState(() {
                            _deletedUrlMedia = [];
                            _urlMedia = [];
                            _controller.text = "";
                          });
                          widget.onCancelEdit();
                        },
                        radius: 14,
                        child: Text(
                          "Отменить",
                          style: context.theme.textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onPickImagePressed() {
    widget.onPickImage();
  }

  void onPickMediaPressed() {
    widget.onPickMedia();
  }

  void onDeleteMedia(bool isExisting, int index) {
    if (!isExisting) {
      widget.onRemoveMediaFromPost(index: index);
    } else {
      setState(() {
        _deletedUrlMedia.add(_urlMedia[index]);
        _urlMedia.removeAt(index);
      });
    }
  }
}
