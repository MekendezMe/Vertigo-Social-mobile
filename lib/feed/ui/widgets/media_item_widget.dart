import 'dart:io';

import 'package:flutter/material.dart';

class MediaItemWidget extends StatelessWidget {
  const MediaItemWidget({
    super.key,
    required this.isExisting,
    this.mediaUrl,
    this.mediaFile,
    required this.isVideo,
  });
  final bool isExisting;
  final String? mediaUrl;
  final File? mediaFile;
  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    if (isVideo) {
      return _buildVideoThumbnail(
        isExisting: isExisting,
        mediaUrl: mediaUrl,
        mediaFile: mediaFile,
      );
    }

    if (isExisting) {
      return Image.network(
        mediaUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    } else {
      return Image.file(
        mediaFile!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    }
  }
}

Widget _buildVideoThumbnail({
  required bool isExisting,
  String? mediaUrl,
  File? mediaFile,
}) {
  return Stack(
    fit: StackFit.expand,
    alignment: Alignment.center,
    children: [
      Container(
        color: Colors.black,
        child: const Center(
          child: Icon(Icons.play_circle_outline, size: 40, color: Colors.white),
        ),
      ),
    ],
  );
}
