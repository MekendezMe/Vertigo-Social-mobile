import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/ui/widgets/button/main_button.dart';

Widget buildLoadingFailure({
  String? error,
  required BuildContext context,
  required VoidCallback onTap,
}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          error ?? "Ошибка при загрузке",
          style: context.theme.textTheme.headlineMedium,
        ),
        SizedBox(height: 8),
        mainButton(context: context, child: Text("Повторить"), onTap: onTap),
      ],
    ),
  );
}
