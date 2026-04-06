import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';

Widget buildAvatar(BuildContext context, String username, String? avatarUrl) {
  final firstLetter = username.isNotEmpty ? username[0].toUpperCase() : '?';
  return avatarUrl != null
      ? ClipOval(
          child: Image.network(
            avatarUrl,
            width: 45,
            height: 45,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return CircleAvatar(
                child: Text(
                  firstLetter,
                  style: context.theme.textTheme.bodyMedium,
                ),
              );
            },
          ),
        )
      : CircleAvatar(
          child: Text(firstLetter, style: context.theme.textTheme.bodyMedium),
        );
}
