import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';

Widget emptyCommentWidget(String text, BuildContext context) {
  return Align(
    alignment: Alignment.topCenter,
    child: Text(text, style: context.theme.textTheme.bodyLarge),
  );
}
