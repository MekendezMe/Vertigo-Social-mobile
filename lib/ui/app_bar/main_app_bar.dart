import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';

PreferredSizeWidget appBar(BuildContext context) {
  return AppBar(
    iconTheme: IconThemeData(color: context.color.dimPurple),
    elevation: 0,
    centerTitle: true,
    title: Image.asset("assets/logo.png", width: 240, height: 240),
    surfaceTintColor: Colors.transparent,
    scrolledUnderElevation: 0,
  );
}
