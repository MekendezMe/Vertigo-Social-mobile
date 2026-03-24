import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';

Widget baseContainerWidget({
  required BuildContext context,
  required Widget child,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    padding: EdgeInsets.only(bottom: 20, top: 14, right: 18, left: 14),
    decoration: BoxDecoration(
      color: context.color.lightGray.withOpacity(0.2),
      borderRadius: BorderRadius.circular(20),
    ),
    child: child,
  );
}
