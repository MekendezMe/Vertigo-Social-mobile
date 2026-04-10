import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/feed/logic/bloc/feed_bloc.dart';
import 'package:social_network_flutter/feed/logic/entites/post.dart';
import 'package:social_network_flutter/feed/logic/entites/user.dart';
import 'package:social_network_flutter/feed/ui/widgets/base_container_widget.dart';
import 'package:social_network_flutter/feed/ui/widgets/base_icon_button.dart';
import 'package:social_network_flutter/feed/ui/widgets/base_icon_container.dart';
import 'package:social_network_flutter/feed/ui/widgets/current_user_widget.dart';
import 'package:social_network_flutter/feed/ui/widgets/image_list.dart';

class PostItemWidget extends StatelessWidget {
  const PostItemWidget({
    super.key,
    required this.post,
    required this.feedBloc,
    required this.onLikePressed,
    required this.onShowGallery,
    required this.onShowComments,
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });
  final Post post;
  final FeedBloc feedBloc;
  final VoidCallback onLikePressed;
  final void Function({
    required BuildContext context,
    required List<String> images,
    required int index,
  })
  onShowGallery;
  final Function({required BuildContext context, required int postId})
  onShowComments;
  final User user;
  final Function({required Post post}) onEdit;
  final Function({required Post post}) onDelete;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        baseContainerWidget(
          context: context,
          child: Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                currentUserWidget(context: context, post: post),
                if (post.images.isNotEmpty) ...[
                  SizedBox(height: 20),

                  SizedBox(
                    height: 150,
                    child: imageList(
                      width: 150,
                      height: 150,
                      post: post,
                      onShowGallery: onShowGallery,
                    ),
                  ),
                ],
                if (post.text.isNotEmpty) ...[
                  SizedBox(height: 20),
                  SelectableText(
                    post.text,
                    style: context.theme.textTheme.bodyMedium,
                  ),
                ],
                SizedBox(height: 20),
                Row(
                  children: [
                    baseIconContainer(
                      context: context,
                      child: baseIconButton(
                        context: context,
                        post: post,
                        onPressed: onLikePressed,
                        iconSize: post.likedByUser ? 25 : 20,
                        icon: Icons.thumb_up,
                        text: "${post.likesCount}",
                        color: post.likedByUser
                            ? context.color.skyBlue
                            : context.color.darkGray,
                      ),
                    ),
                    SizedBox(width: 10),
                    baseIconContainer(
                      context: context,
                      child: baseIconButton(
                        context: context,
                        post: post,
                        onPressed: () =>
                            onShowComments(context: context, postId: post.id),
                        icon: Icons.comment,
                        text: "${post.commentsCount}",
                        color: context.color.darkGray,
                      ),
                    ),
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
            ],
          ),
        ),
      ],
    );
  }
}

// Widget postItemWidget({
//   required BuildContext context,
//   required Post post,
//   required FeedBloc feedBloc,
//   required VoidCallback onLikePressed,
//   required void Function({
//     required BuildContext context,
//     required List<String> images,
//     required int index,
//   })
//   onShowGallery,
//   required Function({required BuildContext context, required int postId})
//   onShowComments,
//   required User user,
//   required Function({required Post post}) onEdit,
//   required Function({required Post post}) onDelete,
// }) {
//   return Stack(
//     clipBehavior: Clip.none,
//     children: [
//       baseContainerWidget(
//         context: context,
//         child: Padding(
//           padding: const EdgeInsets.only(left: 14.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               currentUserWidget(context: context, post: post),
//               if (post.images.isNotEmpty) ...[
//                 SizedBox(height: 20),

//                 SizedBox(
//                   height: 150,
//                   child: imageList(
//                     width: 150,
//                     height: 150,
//                     post: post,
//                     onShowGallery: onShowGallery,
//                   ),
//                 ),
//               ],
//               if (post.text.isNotEmpty) ...[
//                 SizedBox(height: 20),
//                 Text(post.text, style: context.theme.textTheme.bodyMedium),
//               ],
//               SizedBox(height: 20),
//               Row(
//                 children: [
//                   baseIconContainer(
//                     context: context,
//                     child: baseIconButton(
//                       context: context,
//                       post: post,
//                       onPressed: onLikePressed,
//                       iconSize: post.likedByUser ? 25 : 20,
//                       icon: Icons.thumb_up,
//                       text: "${post.likesCount}",
//                       color: post.likedByUser
//                           ? context.color.skyBlue
//                           : context.color.darkGray,
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   baseIconContainer(
//                     context: context,
//                     child: baseIconButton(
//                       context: context,
//                       post: post,
//                       onPressed: () =>
//                           onShowComments(context: context, postId: post.id),
//                       icon: Icons.comment,
//                       text: "${post.commentsCount}",
//                       color: context.color.darkGray,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//       Positioned(
//         right: 18,
//         top: 18,
//         child: PopupMenuButton(
//           icon: Icon(Icons.more_vert),
//           color: context.color.darkGray,
//           iconSize: 30,
//           onSelected: (value) {
//             if (value == "edit") {
//               onEdit(post: post);
//             } else if (value == "delete") {
//               onDelete(post: post);
//             }
//           },
//           itemBuilder: (context) => [
//             if (user.id == post.creator.id) ...[
//               PopupMenuItem(value: "edit", child: Text("Редактировать")),
//               PopupMenuItem(value: "delete", child: Text("Удалить")),
//             ],
//           ],
//         ),
//       ),
//     ],
//   );
// }
