import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_network_flutter/feed/logic/helpers/network_url_checker.dart';

class ModalGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const ModalGallery({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<ModalGallery> createState() => _ModalGalleryState();
}

class _ModalGalleryState extends State<ModalGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Center(
            child: Container(
              constraints: BoxConstraints(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${widget.images.length}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (int index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemCount: widget.images.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Center(
                            child: _buildImage(widget.images[index]),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildImage(String path) {
  if (isNetworkUrl(path)) {
    return Image.network(
      path,
      width: double.infinity,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.broken_image, color: Colors.white, size: 50);
      },
    );
  }

  return Image.file(
    File(path),
    width: double.infinity,
    fit: BoxFit.contain,
    errorBuilder: (context, error, stackTrace) {
      return const Icon(Icons.broken_image, color: Colors.white, size: 50);
    },
  );
}
