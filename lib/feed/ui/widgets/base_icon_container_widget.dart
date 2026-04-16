import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';

class BaseIconContainerWidget extends StatelessWidget {
  const BaseIconContainerWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        color: context.color.blackText.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }
}
