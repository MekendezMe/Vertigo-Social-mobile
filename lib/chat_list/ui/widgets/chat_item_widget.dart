import 'package:flutter/material.dart';
import 'package:social_network_flutter/chat_list/logic/entities/chat.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/feed/logic/entites/user.dart';
import 'package:social_network_flutter/helpers/date_parser.dart';
import 'package:social_network_flutter/ui/widgets/avatar/build_avatar.dart';

class ChatItemWidget extends StatelessWidget {
  const ChatItemWidget({super.key, required this.chat, required this.user});
  final Chat chat;
  final User user;

  @override
  Widget build(BuildContext context) {
    final username = chat.user?.username ?? chat.title ?? "";
    final avatar = chat.user?.avatar ?? chat.avatar;
    String textMessage =
        chat.lastMessage != null && chat.lastMessage!.content != null
        ? chat.lastMessage!.content!
        : "";
    textMessage = textMessage == "" ? "Напишите что-нибудь..." : textMessage;
    final text = textMessage.length > 40
        ? "${textMessage.substring(0, 40)}..."
        : textMessage;

    final lastMessageFromCurrentUser = chat.lastMessage == null
        ? false
        : chat.lastMessage!.senderUser!.id == user.id;
    final formatDate = chat.lastMessage != null
        ? formatMessageDate(chat.lastMessage!.createdAt)
        : "";
    final countUnread = chat.countUnread;
    final isRead = chat.lastMessage != null ? chat.lastMessage!.isRead : false;
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
      width: width * 0.95,
      padding: EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 14),
          Row(
            children: [
              buildAvatar(context, username, avatar),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username, style: context.theme.textTheme.bodyLarge),
                  SizedBox(height: 6),
                  Text(text, style: context.theme.textTheme.bodyMedium),
                ],
              ),
              SizedBox(height: 8),
              Spacer(),
              Row(
                children: [
                  if (lastMessageFromCurrentUser) ...[
                    Text(
                      isRead ? "✓✓" : "✓",
                      style: context.theme.textTheme.bodyMedium!.modify(
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                  if (!lastMessageFromCurrentUser && countUnread > 0) ...[
                    Container(
                      constraints: BoxConstraints(minWidth: 30, minHeight: 30),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      child: Center(
                        child: Text(
                          "${countUnread}",
                          style: context.theme.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                  Text(formatDate, style: context.theme.textTheme.bodyMedium),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
