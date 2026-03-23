import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';

class CustomToastWidget extends StatelessWidget {
  const CustomToastWidget({
    super.key,
    required this.text,
    this.iconWidget,
    this.iconBackgroundColor,
  });
  final String text;
  final Widget? iconWidget;
  final Color? iconBackgroundColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 120),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: context.color.dimPurple,
          ),
          padding: EdgeInsets.only(left: 4, right: 16, top: 7, bottom: 7),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 100,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            // crossAxisAlignment: CrossAxisAlignment.start, // центрировать ли иконку
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Image.asset("assets/logo.png", width: 40, height: 30),
              ),
              Expanded(
                child: Text(text, style: Theme.of(context).textTheme.bodySmall),
              ),
            ],
          ),
        ),
      ),
    );
  }

  CustomToastWidget.error({
    required String text,
    required BuildContext context,
    Key? key,
  }) : this(
         key: key,
         text: text,
         iconWidget: null,
         iconBackgroundColor: context.color.red,
       );
}
