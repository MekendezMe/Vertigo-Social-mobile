import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_network_flutter/feed/logic/helpers/extension_file_checker.dart';
import 'package:social_network_flutter/feed/logic/helpers/network_url_checker.dart';
import 'package:video_player/video_player.dart';

class ModalGallery extends StatefulWidget {
  final List<String> media;
  final int initialIndex;

  const ModalGallery({
    super.key,
    required this.media,
    required this.initialIndex,
  });

  @override
  State<ModalGallery> createState() => _ModalGalleryState();
}

class _ModalGalleryState extends State<ModalGallery> {
  late PageController _pageController;
  late int _currentIndex;
  late List<VideoPlayerController> _videoControllers;
  final Map<int, bool> _isVideoPlaying = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _videoControllers = List.generate(
      widget.media.length,
      (index) =>
          VideoPlayerController.networkUrl(Uri.parse(widget.media[index])),
    );
    _initializeVideos();
  }

  void _initializeVideos() {
    for (var controller in _videoControllers) {
      controller
          .initialize()
          .then((_) {
            if (mounted) setState(() {});
          })
          .catchError((error) {
            debugPrint('Ошибка инициализации видео: $error');
          });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _videoControllers) {
      controller.dispose();
    }
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
              child: Container(color: Colors.black.withOpacity(0.9)),
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
                    '${_currentIndex + 1} / ${widget.media.length}',
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
                      _pauseAllVideos();
                    },
                    itemCount: widget.media.length,
                    itemBuilder: (context, index) {
                      final mediaPath = widget.media[index];
                      final isVideo = isVideoByUrl(mediaPath);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Center(
                          child: isVideo
                              ? _buildVideoPlayer(index, mediaPath)
                              : _buildImage(mediaPath),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  Widget _buildVideoPlayer(int index, String videoUrl) {
    final controller = _videoControllers[index];

    if (!controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final videoAspectRatio = controller.value.aspectRatio;

    double videoWidth = screenWidth - 40;
    double videoHeight = videoWidth / videoAspectRatio;

    final maxHeight = screenHeight * 0.7;
    if (videoHeight > maxHeight) {
      videoHeight = maxHeight;
      videoWidth = videoHeight * videoAspectRatio;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (controller.value.isPlaying) {
            controller.pause();
            _isVideoPlaying[index] = false;
          } else {
            _pauseAllVideos();
            controller.play();
            _isVideoPlaying[index] = true;
          }
        });
      },
      child: Center(
        child: Container(
          width: videoWidth,
          height: videoHeight,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(controller),
                if (!controller.value.isPlaying)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pauseAllVideos() {
    for (var i = 0; i < _videoControllers.length; i++) {
      if (_videoControllers[i].value.isPlaying) {
        _videoControllers[i].pause();
        _isVideoPlaying[i] = false;
      }
    }
  }
}
