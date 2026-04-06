import 'package:flutter/material.dart';
import 'package:social_network_flutter/comment/logic/bloc/comment_bloc.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/comment/logic/entities/comment.dart';
import 'package:social_network_flutter/helpers/date_parser.dart';
import 'package:social_network_flutter/ui/widgets/avatar/build_avatar.dart';

Widget commentItemWidget({
  required BuildContext context,
  required Comment comment,
  required CommentBloc commentBloc,
  required VoidCallback? onReplyPressed,
  required void Function({required Comment comment}) onAnswerPressed,
  required Function({required Comment comment}) onLikePressed,
}) {
  final avatarUrl = comment.author.avatar?.isNotEmpty == true
      ? comment.author.avatar
      : null;
  final createdDate = formatDate(comment.createdAt);
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    padding: EdgeInsets.only(bottom: 16, top: 14, right: 6, left: 10),
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 4,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            buildAvatar(context, comment.author.username, avatarUrl),
            Text(
              comment.author.username,
              style: context.theme.textTheme.bodyMedium,
            ),
            if (comment.answerToUser != null) ...[
              Text(
                "@${comment.answerToUser!.username}",
                style: context.theme.textTheme.bodyMedium!.modify(
                  color: context.color.veryDarkBlueGreen,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 8),
        Text(comment.text, style: context.theme.textTheme.bodyMedium),
        SizedBox(height: 8),
        Row(
          children: [
            Text(createdDate, style: context.theme.textTheme.bodySmall),
            SizedBox(width: 6),
            IconButton(
              onPressed: () => onReplyPressed?.call(),
              icon: Row(
                children: [
                  Icon(Icons.comment),
                  SizedBox(width: 6),
                  Text(
                    "${comment.answersCount}",
                    style: context.theme.textTheme.bodySmall,
                  ),
                ],
              ),
              iconSize: 20,
              color: context.color.darkGray,
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () => onAnswerPressed(comment: comment),
              child: Text("Ответить", style: context.theme.textTheme.bodySmall),
            ),
            Spacer(),
            IconButton(
              onPressed: () => onLikePressed(comment: comment),
              icon: Row(
                children: [
                  Icon(Icons.thumb_up),
                  SizedBox(width: 6),
                  Text(
                    "${comment.likesCount}",
                    style: context.theme.textTheme.bodySmall,
                  ),
                ],
              ),
              iconSize: comment.likedByUser ? 25 : 20,
              color: comment.likedByUser
                  ? context.color.skyBlue
                  : context.color.darkGray,
            ),
          ],
        ),
      ],
    ),
  );
}
