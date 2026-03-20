import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';

Widget mainButton({
  required BuildContext context,
  required Widget child,
  required VoidCallback onTap,
}) {
  return ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(backgroundColor: context.color.purple),
    child: child,
  );
}
