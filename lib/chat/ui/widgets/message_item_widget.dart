import 'package:flutter/material.dart';
import 'package:social_network_flutter/chat_list/logic/entities/message.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/feed/logic/entites/user.dart';
import 'package:social_network_flutter/helpers/chat/parse_content.dart';
import 'package:social_network_flutter/helpers/date_parser.dart';

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
    final textMessage = parseContent(message.content);
    final createdDate = formatMessageDate(message.createdAt);
    bool isRead = message.isRead;
    final width = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: isCurrentUserMessage
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          constraints: BoxConstraints(maxWidth: width * 0.7),
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: isCurrentUserMessage
                ? context.color.purple.withOpacity(0.5)
                : context.color.lightGray.withOpacity(0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(textMessage, style: context.theme.textTheme.bodyLarge),
              SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(createdDate, style: context.theme.textTheme.bodyMedium),
                  if (isCurrentUserMessage) ...[
                    SizedBox(width: 8),
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
