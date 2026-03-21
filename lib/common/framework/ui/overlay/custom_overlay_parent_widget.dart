import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/ui/overlay/custom_overlay.dart';

class CustomOverlayParentWidget extends StatefulWidget {
  final Widget child;

  const CustomOverlayParentWidget({super.key, required this.child});

  @override
  State<CustomOverlayParentWidget> createState() =>
      CustomOverlayParentWidgetState();
}

class CustomOverlayParentWidgetState extends State<CustomOverlayParentWidget> {
  @override
  void initState() {
    super.initState();
    CustomOverlay.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
