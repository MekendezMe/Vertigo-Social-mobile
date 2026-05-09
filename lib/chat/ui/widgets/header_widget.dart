import 'package:flutter/material.dart';
import 'package:social_network_flutter/chat_list/logic/entities/chat.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/ui/widgets/avatar/build_avatar.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required this.chat});
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    final username = chat.user?.username ?? chat.title ?? "Артем Лебедев";
    final avatar = chat.user?.avatar ?? chat.avatar;
    return Container(
      constraints: BoxConstraints(minHeight: 70),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: context.color.lightGray.withOpacity(0.2),
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_left, size: 40),
          ),
          Spacer(),
          buildAvatar(context, username, avatar),
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(username, style: context.theme.textTheme.bodyLarge),
              Text('был недавно', style: context.theme.textTheme.bodyMedium),
            ],
          ),
          Spacer(),
          InkWell(onTap: () {}, child: Icon(Icons.call, size: 25)),
          SizedBox(width: 20),
          InkWell(onTap: () {}, child: Icon(Icons.more_vert, size: 25)),
        ],
      ),
    );
  }
}
