import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/feed/logic/entites/post.dart';
import 'package:social_network_flutter/feed/logic/entites/user.dart';
import 'package:social_network_flutter/helpers/date_parser.dart';
import 'package:social_network_flutter/ui/widgets/avatar/build_avatar.dart';

Widget currentUserWidget({
  required BuildContext context,
  required Post post,
  required Function({required Post post}) onSubscribe,
  required User user,
}) {
  final convertDate = formatCreatedDate(post.createdAt);
  final avatarUrl = post.creator.avatar;
  return Container(
    padding: EdgeInsets.only(top: 10),
    child: Row(
      children: [
        Container(
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: buildAvatar(context, post.creator.username, avatarUrl),
        ),
        SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              splashFactory: NoSplash.splashFactory,
              onTap: () => onSubscribe(post: post),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SelectableText(
                    post.creator.username,
                    style: context.theme.textTheme.bodyLarge!.modify(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (!post.subscribedByUser && user.id != post.creator.id) ...[
                    SizedBox(width: 8),
                    Icon(
                      Icons.person_add,
                      size: 20,
                      color: context.color.purple.withOpacity(0.8),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 4),
            SelectableText(
              convertDate,
              style: context.theme.textTheme.bodyMedium!.modify(
                color: context.theme.textTheme.bodyMedium!.color!.withOpacity(
                  0.6,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
