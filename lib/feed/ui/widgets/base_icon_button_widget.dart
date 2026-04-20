import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/post/logic/entities/post.dart';

class BaseIconButtonWidget extends StatelessWidget {
  const BaseIconButtonWidget({
    super.key,
    required this.post,
    required this.onPressed,
    required this.icon,
    required this.text,
    required this.color,
    this.iconSize,
  });
  final Post post;
  final VoidCallback onPressed;
  final IconData icon;
  final String text;
  final Color color;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: null,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      padding: EdgeInsets.only(left: 10, right: 4),
      constraints: BoxConstraints(),
      color: color,
      style: IconButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        overlayColor: Colors.transparent,
      ),
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize ?? 20),
          SizedBox(width: 6),
          Text(
            text,
            style: context.theme.textTheme.bodySmall!.modify(
              color: context.color.veryDarkGray.withOpacity(0.9),
            ),
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
