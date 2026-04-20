import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/post/logic/entities/post.dart';
import 'package:social_network_flutter/feed/logic/entites/user.dart';
import 'package:social_network_flutter/feed/ui/widgets/base_container_widget.dart';
import 'package:social_network_flutter/feed/ui/widgets/base_icon_button_widget.dart';
import 'package:social_network_flutter/feed/ui/widgets/base_icon_container_widget.dart';
import 'package:social_network_flutter/feed/ui/widgets/current_user_widget.dart';
import 'package:social_network_flutter/feed/ui/widgets/media_list.dart';

class PostItemWidget extends StatelessWidget {
  const PostItemWidget({
    super.key,
    required this.post,
    required this.onLikePressed,
    required this.onShowGallery,
    required this.onShowComments,
    required this.user,
    required this.onEdit,
    required this.onDelete,
    required this.onSubscribe,
  });
  final Post post;
  final VoidCallback onLikePressed;
  final void Function({
    required BuildContext context,
    required List<String> media,
    required int index,
  })
  onShowGallery;
  final Function({required BuildContext context, required int postId})?
  onShowComments;
  final User user;
  final Function({required Post post}) onEdit;
  final Function({required Post post}) onDelete;
  final Function({required Post post}) onSubscribe;
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        BaseContainerWidget(
          child: Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CurrentUserWidget(
                  post: post,
                  onSubscribe: onSubscribe,
                  user: user,
                ),
                if (post.media.isNotEmpty) ...[
                  SizedBox(height: 10),

                  SizedBox(
                    height: 240,
                    child: MediaListWidget(
                      width: 200,
                      height: 200,
                      post: post,
                      onShowGallery: onShowGallery,
                    ),
                  ),
                ],
                if (post.text.isNotEmpty) ...[
                  SizedBox(height: 20),
                  SelectableText(
                    post.text,
                    style: context.theme.textTheme.bodyLarge,
                  ),
                ],
                SizedBox(height: 14),
                Row(
                  children: [
                    BaseIconContainerWidget(
                      child: BaseIconButtonWidget(
                        post: post,
                        onPressed: onLikePressed,
                        iconSize: post.likedByUser ? 25 : 20,
                        icon: Icons.thumb_up,
                        text: "${post.likesCount}",
                        color: post.likedByUser
                            ? context.color.skyBlue
                            : context.color.veryDarkGray,
                      ),
                    ),
                    SizedBox(width: 10),
                    if (onShowComments != null) ...[
                      BaseIconContainerWidget(
                        child: BaseIconButtonWidget(
                          post: post,
                          onPressed: () => onShowComments!(
                            context: context,
                            postId: post.id,
                          ),
                          icon: Icons.comment,
                          text: "${post.commentsCount}",
                          color: context.color.veryDarkGray,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 18,
          top: 18,
          child: PopupMenuButton(
            borderRadius: BorderRadius.circular(14),
            position: PopupMenuPosition.over,
            style: IconButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              overlayColor: Colors.transparent,
            ),
            icon: Icon(Icons.more_vert),
            color: context.color.darkGray,
            iconSize: 30,
            onSelected: (value) {
              if (value == "edit") {
                onEdit(post: post);
              } else if (value == "delete") {
                onDelete(post: post);
              }
            },
            itemBuilder: (context) => [
              if (user.id == post.creator.id) ...[
                PopupMenuItem(value: "edit", child: Text("Редактировать")),
                PopupMenuItem(value: "delete", child: Text("Удалить")),
              ],
              PopupMenuItem(value: "copy", child: Text("Копировать")),
            ],
          ),
        ),
      ],
    );
  }
}
