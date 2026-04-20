import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/post/logic/entities/post_types.dart';

List<Tab> buildTabs(BuildContext context, PostType currentType) {
  return [
    Tab(
      child: Text(
        "Все",
        style: currentType == PostType.all
            ? context.theme.textTheme.bodyLarge
            : context.theme.textTheme.bodyLarge!.modify(
                color: context.color.veryDarkGray.withOpacity(0.8),
              ),
      ),
    ),
    Tab(
      child: Text(
        "Рекомендованное",
        style: currentType == PostType.recommended
            ? context.theme.textTheme.bodyLarge
            : context.theme.textTheme.bodyLarge!.modify(
                color: context.color.veryDarkGray.withOpacity(0.8),
              ),
      ),
    ),
    Tab(
      child: Text(
        "Подписки",
        style: currentType == PostType.subscribe
            ? context.theme.textTheme.bodyLarge
            : context.theme.textTheme.bodyLarge!.modify(
                color: context.color.veryDarkGray.withOpacity(0.8),
              ),
      ),
    ),
  ];
}
