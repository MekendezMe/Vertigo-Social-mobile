import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';

class BaseContainerWidget extends StatelessWidget {
  const BaseContainerWidget({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 14),
      padding: EdgeInsets.only(bottom: 20, top: 14, right: 18, left: 14),
      decoration: BoxDecoration(
        color: context.color.lightGray.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
