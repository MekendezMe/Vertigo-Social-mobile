import 'package:flutter/material.dart';
import 'package:social_network_flutter/comment/logic/bloc/comment_bloc.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/feed/logic/entites/comment.dart';
import 'package:social_network_flutter/helpers/date_parser.dart';

Widget commentItemWidget({
  required BuildContext context,
  required Comment comment,
  required CommentBloc commentBloc,
}) {
  final avatarUrl = comment.author.avatar?.isNotEmpty == true
      ? comment.author.avatar
      : null;
  final createdDate = formatDate(comment.createdAt);
  final firstLetter = comment.author.username.isNotEmpty
      ? comment.author.username[0].toUpperCase()
      : '?';
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    padding: EdgeInsets.only(bottom: 20, top: 14, right: 18, left: 14),
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (avatarUrl != null)
              ClipOval(
                child: Image.network(
                  avatarUrl,
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return CircleAvatar(
                      child: Text(
                        firstLetter,
                        style: context.theme.textTheme.bodyMedium,
                      ),
                    );
                  },
                ),
              )
            else
              CircleAvatar(
                child: Text(
                  firstLetter,
                  style: context.theme.textTheme.bodyMedium,
                ),
              ),
            SizedBox(width: 6),
            Text(
              comment.author.username,
              style: context.theme.textTheme.bodyMedium,
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(comment.text, style: context.theme.textTheme.bodyMedium),
        SizedBox(height: 8),
        Row(
          children: [
            Text(createdDate, style: context.theme.textTheme.bodySmall),
            SizedBox(width: 6),
            Row(
              children: [
                IconButton(
                  onPressed: () => _onShowAnswers(
                    commentBloc: commentBloc,
                    comment: comment,
                  ),
                  icon: Icon(Icons.comment),
                  iconSize: 20,
                  color: context.color.darkGray,
                ),
                SizedBox(width: 6),
                Text(
                  "${comment.answersCount}",
                  style: context.theme.textTheme.bodySmall,
                ),
              ],
            ),
            SizedBox(width: 6),
            Text("Ответить", style: context.theme.textTheme.bodySmall),
            Spacer(),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.thumb_up),
                  iconSize: comment.likedByUser ? 25 : 20,
                  color: comment.likedByUser
                      ? context.color.skyBlue
                      : context.color.darkGray,
                ),
                SizedBox(width: 6),
                Text(
                  "${comment.likesCount}",
                  style: context.theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

void _onShowAnswers({
  required CommentBloc commentBloc,
  required Comment comment,
}) {}
