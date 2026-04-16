import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullscreenVideoModal extends StatefulWidget {
  final VideoPlayerController controller;

  const FullscreenVideoModal({super.key, required this.controller});

  @override
  State<FullscreenVideoModal> createState() => _FullscreenVideoModalState();
}

class _FullscreenVideoModalState extends State<FullscreenVideoModal> {
  bool _isPlaying = false;
  bool _isEnded = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (mounted) {
        setState(() {
          _isPlaying = widget.controller.value.isPlaying;
          _isEnded =
              widget.controller.value.position ==
              widget.controller.value.duration;
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.controller.value.position ==
          widget.controller.value.duration) {
        widget.controller.seekTo(Duration.zero);
      }
      widget.controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isPlaying && !_isEnded) {
          widget.controller.pause();
        } else if (!_isPlaying && !_isEnded) {
          widget.controller.play();
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: widget.controller.value.aspectRatio,
                child: VideoPlayer(widget.controller),
              ),
            ),

            if (!_isPlaying || _isEnded)
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (_isEnded) {
                      widget.controller.seekTo(Duration.zero);
                      widget.controller.play();
                    } else {
                      widget.controller.play();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Icon(
                      _isEnded ? Icons.replay : Icons.play_arrow,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            Positioned(
              top: 40,
              right: 16,
              child: GestureDetector(
                onTap: () {},
                child: IconButton(
                  onPressed: () {
                    widget.controller.pause();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () {
                          if (_isPlaying) {
                            widget.controller.pause();
                          } else {
                            if (_isEnded) {
                              widget.controller.seekTo(Duration.zero);
                            }
                            widget.controller.play();
                          }
                        },
                      ),
                      Text(
                        _formatDuration(widget.controller.value.position),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: VideoProgressIndicator(
                            widget.controller,
                            allowScrubbing: true,
                            colors: const VideoProgressColors(
                              playedColor: Colors.blue,
                              backgroundColor: Colors.grey,
                              bufferedColor: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _formatDuration(widget.controller.value.duration),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    super.dispose();
  }
}
