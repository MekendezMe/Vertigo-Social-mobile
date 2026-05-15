import 'package:flutter/material.dart';
import 'package:social_network_flutter/chat_list/logic/entities/message.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/feed/logic/entites/user.dart';
import 'package:social_network_flutter/helpers/date_parser.dart';
import 'package:social_network_flutter/ui/widgets/avatar/build_avatar.dart';
import 'package:social_network_flutter/ui/widgets/video/story_video_tile.dart';
import 'package:social_network_flutter/ui/widgets/video/voice_message_player.dart';

class MessageItemWidget extends StatelessWidget {
  const MessageItemWidget({
    super.key,
    required this.message,
    required this.user,
  });
  final Message message;
  final User user;

  @override
  Widget build(BuildContext context) {
    final isCurrentUserMessage = message.senderUser!.id == user.id;
    final textMessage = message.content ?? "";
    final createdDate = formatMessageDate(message.createdAt);
    bool isRead = message.isRead;
    final width = MediaQuery.of(context).size.width;
    final isCircle = message.type == 'circle';
    final isAudio = message.type == 'audio';
    final media = message.media.isNotEmpty && (isCircle || isAudio)
        ? message.media[0]
        : null;
    final isForwarded = message.forwardedFromUser != null;
    final isReply = message.replyToMessage != null;
    final withPost = message.post != null;
    final forwardedUsername = message.forwardedFromUser?.username;
    final forwardedAvatar = message.forwardedFromUser?.avatar;

    return Row(
      mainAxisAlignment: isCurrentUserMessage
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        if (isCircle) ...[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: StoryVideoTile(videoUrl: media!),
          ),
        ] else if (isAudio) ...[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: VoiceMessagePlayer(audioUrl: media!),
          ),
        ] else
          Container(
            margin: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            constraints: BoxConstraints(maxWidth: width * 0.6),
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: isCurrentUserMessage
                  ? context.color.purple.withOpacity(0.5)
                  : context.color.lightGray.withOpacity(0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isForwarded) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Переслано от",
                          style: context.theme.textTheme.bodySmall,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildAvatar(
                              context,
                              forwardedUsername!,
                              forwardedAvatar!,
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(width: 4),
                            Text(
                              forwardedUsername,
                              style: context.theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                ],

                if (isReply) ...[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: isCurrentUserMessage
                            ? Colors.white.withOpacity(0.15)
                            : Colors.black.withOpacity(0.08),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 3,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.replyToMessage!.senderUser!.username,
                                  style: context.theme.textTheme.bodySmall,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  message.replyToMessage!.content ?? "Текст",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                ],

                Text(
                  textMessage,
                  style: context.theme.textTheme.bodyLarge,
                  softWrap: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      createdDate,
                      style: context.theme.textTheme.bodyMedium,
                    ),
                    if (isCurrentUserMessage) ...[
                      const SizedBox(width: 6),
                      Text(
                        isRead ? "✓✓" : "✓",
                        style: context.theme.textTheme.bodyMedium!.modify(
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
