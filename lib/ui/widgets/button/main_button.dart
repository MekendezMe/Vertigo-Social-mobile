import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';

Widget mainButton({
  required BuildContext context,
  required Widget child,
  required VoidCallback onTap,
  Color? backgroundColor,
  double? radius,
}) {
  return ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? context.color.purple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? 20),
      ),
    ),
    child: child,
  );
}
