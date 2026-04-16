import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';

class ButtonMediaWidget extends StatelessWidget {
  const ButtonMediaWidget({
    super.key,
    required this.onPickImagePressed,
    required this.onPickMediaPressed,
  });
  final VoidCallback onPickImagePressed;
  final VoidCallback onPickMediaPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          style: IconButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            overlayColor: Colors.transparent,
          ),
          iconSize: 25,
          onPressed: () => onPickImagePressed(),
          icon: Icon(Icons.photo),
          color: context.color.gray,
        ),
        IconButton(
          padding: EdgeInsets.zero,
          style: IconButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            overlayColor: Colors.transparent,
          ),
          iconSize: 25,
          onPressed: () => onPickMediaPressed(),
          icon: Icon(Icons.attach_file),
          color: context.color.gray,
        ),
      ],
    );
  }
}
