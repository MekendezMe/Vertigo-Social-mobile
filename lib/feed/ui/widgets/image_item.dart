import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_network_flutter/feed/logic/helpers/network_url_checker.dart';

Widget imageItem({
  required String path,
  required int index,
  required double width,
  required double height,
}) {
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
