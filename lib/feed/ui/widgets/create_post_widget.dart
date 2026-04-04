import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/feed/logic/bloc/feed_bloc.dart';
import 'package:social_network_flutter/feed/ui/widgets/base_container_widget.dart';
import 'package:social_network_flutter/ui/widgets/button/main_button.dart';
import 'package:social_network_flutter/ui/widgets/custom_circular_progress_indicator.dart';
import 'package:social_network_flutter/ui/widgets/text_field/main_text_field.dart';

class CreatePostWidget extends StatefulWidget {
  const CreatePostWidget({
    super.key,
    required this.state,
    required this.feedBloc,
    required this.onPostCreated,
  });
  final FeedLoaded state;
  final FeedBloc feedBloc;
  final VoidCallback onPostCreated;

  @override
  State<CreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isInputError = false;
  @override
  void dispose() {
    _controller.dispose();
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

    widget.feedBloc.add(CreatePost(text: _controller.text, images: images));

    _controller.clear();
    widget.onPostCreated();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
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
                          controller: _controller,
                          style: context.theme.textTheme.bodyLarge!,
                          hintText: "Что у вас нового?",
                          radius: 24,
                          onChanged: _onChanged,
                          isInputError: _isInputError,
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
