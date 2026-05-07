import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/ui/widgets/drawer/screen_item.dart';

enum TypeScreen { feed, profile, settings, messages }

class Screen {
  final TypeScreen name;
  final String text;
  final Icon icon;

  Screen({required this.name, required this.text, required this.icon});
}

List<Screen> screens = [
  Screen(name: TypeScreen.feed, text: "Лента", icon: Icon(Icons.feed)),
  Screen(name: TypeScreen.profile, text: "Профиль", icon: Icon(Icons.person)),
  Screen(
    name: TypeScreen.settings,
    text: "Настройки",
    icon: Icon(Icons.settings),
  ),
  Screen(
    name: TypeScreen.messages,
    text: "Сообщения",
    icon: Icon(Icons.message),
  ),
];

Widget customDrawer({
  required BuildContext context,
  required TypeScreen active,
  required VoidCallback? onShowMain,
  required VoidCallback? onShowProfile,
  required VoidCallback? onShowSettings,
  required VoidCallback? onShowChatList,
}) {
  final Map<TypeScreen, VoidCallback?> onTapMap = {
    TypeScreen.feed: onShowMain,
    TypeScreen.profile: onShowProfile,
    TypeScreen.settings: onShowSettings,
    TypeScreen.messages: onShowChatList,
  };
  return Drawer(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(8),
        bottomRight: Radius.circular(8),
      ),
    ),
    backgroundColor: context.color.gray,
    width: MediaQuery.of(context).size.width / 1.5,
    elevation: 0,
    child: ListView.separated(
      padding: EdgeInsets.only(left: 10, right: 10, top: 40),
      itemCount: screens.length,
      separatorBuilder: (context, index) {
        return SizedBox(height: 20);
      },
      itemBuilder: (context, index) {
        final screen = screens[index];
        return screenItem(
          context: context,
          screen: screen,
          active: active,
          onTap: onTapMap[screen.name],
        );
      },
    ),
  );
}
