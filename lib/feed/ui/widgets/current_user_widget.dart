import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/feed/logic/entites/post.dart';
import 'package:social_network_flutter/helpers/date_parser.dart';
import 'package:social_network_flutter/ui/widgets/avatar/build_avatar.dart';

Widget currentUserWidget({required BuildContext context, required Post post}) {
  DateTime createdAt = parseCustomDate(post.createdAt);
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
            Row(
              children: [
                Text(
                  post.creator.username,
                  style: context.theme.textTheme.bodyMedium,
                ),
              ],
            ),
            Text("сегодня в ${createdAt.hour}:${createdAt.minute}"),
          ],
        ),
      ],
    ),
  );
}
