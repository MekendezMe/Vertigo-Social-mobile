import 'package:flutter/material.dart';
import 'package:social_network_flutter/ui/widgets/post/modal_gallery_widget.dart';

void showGallery(BuildContext context, List<String> media, int initialIndex) {
  showDialog(
    context: context,
    builder: (context) =>
        ModalGallery(media: media, initialIndex: initialIndex),
  );
}
