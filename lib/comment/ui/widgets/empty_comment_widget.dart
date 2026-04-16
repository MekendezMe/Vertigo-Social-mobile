import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';

class EmptyCommentWidget extends StatelessWidget {
  const EmptyCommentWidget({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Text(text, style: context.theme.textTheme.bodyLarge),
    );
  }
}
