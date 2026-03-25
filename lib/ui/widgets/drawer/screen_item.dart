import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/ui/widgets/drawer/custom_drawer.dart';

Widget screenItem({
  required BuildContext context,
  required Screen screen,
  required TypeScreen active,
  VoidCallback? onTap,
}) {
  return Container(
    decoration: screen.name == active
        ? BoxDecoration(
            color: context.color.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          )
        : null,
    child: ListTile(
      leading: screen.icon,
      title: Text(screen.text, style: context.theme.textTheme.bodyMedium),
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.pop(context);
        onTap?.call();
      },
    ),
  );
}
