import 'package:flutter/material.dart';
import 'package:social_network_flutter/feed/logic/entites/post.dart';
import 'package:social_network_flutter/feed/ui/widgets/image_item.dart';

Widget imageList({
  required double width,
  required double height,
  required Post post,
  required void Function({
    required BuildContext context,
    required List<String> images,
    required int index,
  })
  onShowGallery,
}) {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: post.images.length,
    itemBuilder: (context, index) {
      return Container(
        margin: EdgeInsets.only(right: 10),
        child: GestureDetector(
          onTap: () => onShowGallery(
            context: context,
            images: post.images,
            index: index,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageItem(
              path: post.images[index],
              index: index,
              width: width,
              height: height,
            ),
          ),
        ),
      );
    },
  );
}
