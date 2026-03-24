import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/feed/logic/entites/post.dart';
import 'package:social_network_flutter/feed/ui/widgets/base_container_widget.dart';

Widget postItemWidget({required BuildContext context, required Post post}) {
  final avatarUrl = post.creator.avatar;
  final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;
  return baseContainerWidget(
    context: context,
    child: Padding(
      padding: const EdgeInsets.only(left: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: hasAvatar
                        ? Image.network(
                            avatarUrl,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          post.creator.name,
                          style: context.theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Text(
                      "сегодня в ${post.createdAt.hour}:${post.createdAt.minute}",
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(post.text, style: context.theme.textTheme.bodyMedium),
          SizedBox(height: 20),
          Row(
            children: [
              _baseIconContainer(
                context: context,
                child: IconButton(
                  padding: EdgeInsets.only(
                    left: 10,
                    top: 8,
                    bottom: 8,
                    right: 4,
                  ),
                  constraints: BoxConstraints(),
                  color: post.likeByUser
                      ? context.color.skyBlue
                      : context.color.gray,
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.thumb_up, size: 20),
                      SizedBox(width: 6),
                      Text(
                        "${post.likesCount}",
                        style: post.likeByUser
                            ? context.theme.textTheme.bodySmall
                            : context.theme.textTheme.bodySmall!.modify(
                                color: context.color.veryDarkGray.withOpacity(
                                  0.9,
                                ),
                              ),
                      ),
                    ],
                  ),
                  onPressed: () {},
                ),
              ),
              SizedBox(width: 10),
              _baseIconContainer(
                context: context,
                child: IconButton(
                  padding: EdgeInsets.only(
                    left: 10,
                    top: 8,
                    bottom: 8,
                    right: 4,
                  ),
                  constraints: BoxConstraints(),
                  color: context.color.darkGray,
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.comment, size: 20),
                      SizedBox(width: 6),
                      Text(
                        "${post.commentsCount}",
                        style: context.theme.textTheme.bodySmall!.modify(
                          color: context.color.veryDarkGray.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _baseIconContainer({
  required BuildContext context,
  required Widget child,
}) {
  return Container(
    padding: EdgeInsets.only(right: 10),
    decoration: BoxDecoration(
      color: context.color.blackText.withOpacity(0.1),
      borderRadius: BorderRadius.circular(24),
    ),
    child: child,
  );
}
