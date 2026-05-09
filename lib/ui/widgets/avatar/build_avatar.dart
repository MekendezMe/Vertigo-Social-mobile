import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';

Widget buildAvatar(
  BuildContext context,
  String username,
  String? avatarUrl, {
  double? width,
  double? height,
}) {
  final firstLetter = username.isNotEmpty ? username[0].toUpperCase() : '?';
  final uri = avatarUrl == null ? null : Uri.tryParse(avatarUrl.trim());
  final hasValidAvatar =
      uri != null &&
      (uri.scheme == 'http' || uri.scheme == 'https') &&
      uri.host.isNotEmpty;

  return hasValidAvatar
      ? ClipOval(
          child: Image.network(
            avatarUrl!.trim(),
            width: width ?? 45,
            height: height ?? 45,
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
