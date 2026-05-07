import 'package:flutter/material.dart';
import 'package:social_network_flutter/chat_list/logic/entities/chat.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/ui/widgets/avatar/build_avatar.dart';

class ChatItemWidget extends StatelessWidget {
  const ChatItemWidget({super.key, required this.chat});
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    final username = chat.user?.username ?? chat.title ?? "";
    final avatar = chat.user?.avatar ?? chat.avatar ?? "";
    final textMessage = chat.lastMessage != null
        ? chat.lastMessage!.content is Map
              ? ((chat.lastMessage!.content as Map)['text'] as String? ?? "")
              : ""
        : "";
    final text = textMessage.length > 40
        ? "${textMessage.substring(0, 40)}..."
        : textMessage;
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.95,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: context.color.darkGray, height: 1, thickness: 0.5),
          Row(
            children: [
              buildAvatar(context, username, avatar),
              SizedBox(width: 8),
              Column(
                children: [
                  Text(username, style: context.theme.textTheme.headlineMedium),
                  SizedBox(height: 6),
                  Text(text, style: context.theme.textTheme.bodyLarge),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
