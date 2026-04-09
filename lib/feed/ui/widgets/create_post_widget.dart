import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/common/framework/ui/toast/custom_toast.dart';
import 'package:social_network_flutter/common/framework/ui/toast/custom_toast_widget.dart';
import 'package:social_network_flutter/feed/logic/bloc/feed_bloc.dart';
import 'package:social_network_flutter/feed/ui/widgets/base_container_widget.dart';
import 'package:social_network_flutter/ui/widgets/avatar/build_avatar.dart';
import 'package:social_network_flutter/ui/widgets/button/main_button.dart';
import 'package:social_network_flutter/ui/widgets/custom_circular_progress_indicator.dart';
import 'package:social_network_flutter/ui/widgets/text_field/main_text_field.dart';

class CreatePostWidget extends StatefulWidget {
  const CreatePostWidget({
    super.key,
    required this.state,
    required this.feedBloc,
    required this.onPostCreated,
    required this.onShowGallery,
  });
  final FeedBloc feedBloc;
  final VoidCallback onPostCreated;
  final FeedLoaded state;
  final void Function({
    required BuildContext context,
    required List<String> images,
    required int index,
  })
  onShowGallery;

  @override
  State<CreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isInputError = false;
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

  void _onCreatePost(int userId, List<File> images) {
    if (_controller.text.isEmpty && images.isEmpty) {
      setState(() {
        _isInputError = true;
      });
      return;
    }
    setState(() {
      _isInputError = false;
    });

    widget.feedBloc.add(CreatePost(text: _controller.text, images: images));
  }

  void afterCreate() {
    setState(() {
      _controller.clear();
    });
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedBloc, FeedState>(
      listenWhen: (previous, current) {
        return (previous is FeedLoaded && current is FeedLoaded) &&
            (previous.isCreating != current.isCreating);
      },
      buildWhen: (previous, current) {
        if (previous is FeedLoaded && current is FeedLoaded) {
          final previousPaths = previous.images
              ?.map((file) => file.path)
              .toList();
          final currentPaths = current.images
              ?.map((file) => file.path)
              .toList();
          final imagesChanged =
              previousPaths.toString() != currentPaths.toString();

          return imagesChanged ||
              previous.isCreating != current.isCreating ||
              previous.isCreateSuccess != current.isCreateSuccess;
        }
        return false;
      },
      bloc: widget.feedBloc,
      listener: (context, state) {
        if (state is FeedLoaded) {
          if (state.isCreateSuccess) {
            CustomToast.show(
              CustomToastWidget(text: "Пост успешно создан!"),
              dismissAfter: Duration(milliseconds: 1500),
            );
            afterCreate();
          }
          if (!state.isCreating && !state.isCreateSuccess) {
            CustomToast.show(
              CustomToastWidget(
                text: "Ошибка при создании поста. Попробуйте еще раз",
              ),
              dismissAfter: Duration(milliseconds: 1500),
            );
            setState(() {
              _isInputError = false;
            });
            _focusNode.requestFocus();
          }
        }
      },
      builder: (context, state) {
        if (state is FeedLoaded) {
          final currentImages = state.images ?? [];
          final avatarUrl = state.user.avatar;
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
                        child: buildAvatar(
                          context,
                          state.user.username,
                          avatarUrl,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              child: mainTextField(
                                context: context,
                                controller: _controller,
                                style: context.theme.textTheme.bodyLarge!,
                                hintText: "Что у вас нового?",
                                radius: 24,
                                onChanged: _onChanged,
                                isInputError: _isInputError,
                                focusNode: _focusNode,
                              ),
                            ),
                            SizedBox(height: 18),
                            _buildImageGrid(currentImages),
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
                          style: IconButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                            highlightColor: Colors.transparent,
                            overlayColor: Colors.transparent,
                          ),
                          iconSize: 25,
                          onPressed: () {
                            widget.feedBloc.add(PickImageFromCamera());
                          },
                          icon: Icon(Icons.photo),
                          color: context.color.gray,
                        ),
                        IconButton(
                          style: IconButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                            highlightColor: Colors.transparent,
                            overlayColor: Colors.transparent,
                          ),
                          iconSize: 25,
                          onPressed: () {
                            widget.feedBloc.add(PickImagesFromGallery());
                          },
                          icon: Icon(Icons.attach_file),
                          color: context.color.gray,
                        ),
                        IconButton(
                          style: IconButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                            highlightColor: Colors.transparent,
                            overlayColor: Colors.transparent,
                          ),
                          iconSize: 25,
                          onPressed: () {},
                          icon: Icon(Icons.emoji_emotions),
                          color: context.color.gray,
                        ),
                      ],
                    ),
                    Spacer(),
                    AnimatedContainer(
                      constraints: BoxConstraints(minWidth: 150),
                      duration: Duration(milliseconds: 300),
                      height: 55,
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: mainButton(
                        backgroundColor: context.color.dimPurple.withOpacity(
                          0.8,
                        ),
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
                        onTap: () =>
                            _onCreatePost(state.user.id, currentImages),
                        radius: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildImageGrid(List<File> images) {
    return GridView.builder(
      key: ValueKey(images.length),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: () => widget.onShowGallery(
                context: context,
                images: images.map((image) => image.path).toList(),
                index: index,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(images[index], fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () {
                  widget.feedBloc.add(RemoveImageFromPost(index: index));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, size: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
