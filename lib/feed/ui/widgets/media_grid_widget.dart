import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_network_flutter/feed/logic/helpers/extension_file_checker.dart';
import 'package:social_network_flutter/feed/ui/widgets/media_item_widget.dart';

class MediaGridWidget extends StatelessWidget {
  const MediaGridWidget({
    super.key,
    required this.mediaFiles,
    required this.urlMedia,
    required this.onShowGallery,
    required this.onDeleteMedia,
  });
  final List<File> mediaFiles;
  final List<String> urlMedia;
  final void Function({
    required BuildContext context,
    required List<String> media,
    required int index,
  })
  onShowGallery;
  final Function({required bool isExisting, required int index}) onDeleteMedia;

  @override
  Widget build(BuildContext context) {
    final totalCount = urlMedia.length + mediaFiles.length;

    if (totalCount == 0) return const SizedBox.shrink();

    return GridView.builder(
      key: ValueKey(totalCount),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: totalCount,
      itemBuilder: (context, index) {
        final bool isExisting = index < urlMedia.length;
        final mediaUrl = isExisting ? urlMedia[index] : null;
        final mediaFile = !isExisting
            ? mediaFiles[index - urlMedia.length]
            : null;

        final bool isVideo = isExisting
            ? isVideoByUrl(mediaUrl!)
            : isVideoByFile(mediaFile!);

        return Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: () {
                final allPaths = [
                  ...urlMedia,
                  ...mediaFiles.map((f) => f.path),
                ];
                onShowGallery(context: context, media: allPaths, index: index);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: MediaItemWidget(
                  isExisting: isExisting,
                  mediaUrl: mediaUrl,
                  mediaFile: mediaFile,
                  isVideo: isVideo,
                ),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () =>
                    onDeleteMedia(index: index, isExisting: isExisting),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
