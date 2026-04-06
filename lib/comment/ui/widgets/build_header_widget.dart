import 'package:flutter/material.dart';
import 'package:social_network_flutter/comment/logic/helpers/navigation_type_helper.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';

Widget buildHeader(
  BuildContext context,
  NavigationItem current,
  bool canGoBack,
  Function onNavigateBack,
) {
  final title = current.type == NavigationType.comments
      ? 'Комментарии'
      : 'Ответы';

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Row(
      children: [
        if (canGoBack)
          IconButton(
            onPressed: () => onNavigateBack(),
            icon: const Icon(Icons.arrow_back),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          )
        else
          const SizedBox(width: 40),

        const SizedBox(width: 8),

        Expanded(
          child: Center(
            child: Text(title, style: context.theme.textTheme.bodyLarge),
          ),
        ),

        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    ),
  );
}
