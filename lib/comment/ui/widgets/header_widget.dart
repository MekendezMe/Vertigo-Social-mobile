import 'package:flutter/material.dart';
import 'package:social_network_flutter/comment/logic/helpers/navigation_type_helper.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required this.current,
    required this.canGoBack,
    required this.onNavigateBack,
    this.showClose = true,
  });
  final NavigationItem current;
  final bool canGoBack;
  final Function onNavigateBack;
  final bool showClose;

  @override
  Widget build(BuildContext context) {
    final title = current.type == NavigationType.comments
        ? 'Комментарии'
        : 'Ответы';
    final double verticalPadding = showClose ? 4 : 14;
    final double horizontalPadding = !showClose ? 4 : 16;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        children: [
          if (canGoBack)
            IconButton(
              style: IconButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
                overlayColor: Colors.transparent,
              ),
              onPressed: () => onNavigateBack(),
              icon: const Icon(Icons.arrow_back),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            )
          else if (showClose)
            const SizedBox(width: 40)
          else
            const SizedBox(width: 48),

          const SizedBox(width: 8),

          Expanded(
            child: Center(
              child: SelectableText(
                title,
                style: context.theme.textTheme.bodyLarge,
              ),
            ),
          ),

          if (showClose)
            IconButton(
              style: IconButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
                overlayColor: Colors.transparent,
              ),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}
