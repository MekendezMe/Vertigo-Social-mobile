import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_network_flutter/feed/logic/helpers/network_url_checker.dart';

class ImageItemWidget extends StatelessWidget {
  const ImageItemWidget({
    super.key,
    required this.path,
    required this.index,
    required this.width,
    required this.height,
  });
  final String path;
  final int index;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (isNetworkUrl(path)) {
      return Image.network(
        path,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Icon(Icons.broken_image, color: Colors.white, size: 50),
          );
        },
      );
    } else {
      return Image.file(
        File(path),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Icon(Icons.broken_image, color: Colors.white, size: 50),
          );
        },
      );
    }
  }
}
