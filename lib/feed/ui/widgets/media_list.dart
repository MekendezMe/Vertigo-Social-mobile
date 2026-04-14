import 'package:flutter/material.dart';
import 'package:social_network_flutter/feed/logic/entites/post.dart';
import 'package:social_network_flutter/feed/logic/helpers/extension_file_checker.dart';
import 'package:social_network_flutter/feed/ui/widgets/image_item.dart';
import 'package:social_network_flutter/feed/ui/widgets/video_list_item.dart';

Widget mediaList({
  required double width,
  required double height,
  required Post post,
  required void Function({
    required BuildContext context,
    required List<String> media,
    required int index,
  })
  onShowGallery,
}) {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: post.media.length,
    itemBuilder: (context, index) {
      final mediaPath = post.media[index];
      final isVideo = isVideoByUrl(mediaPath);

      return Container(
        margin: const EdgeInsets.only(right: 10),
        child: GestureDetector(
          onTap: () =>
              onShowGallery(context: context, media: post.media, index: index),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: isVideo
                ? VideoListItem(
                    key: ValueKey("${post.id}_video"),
                    videoUrl: mediaPath,
                  )
                : imageItem(
                    path: mediaPath,
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
