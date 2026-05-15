import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:video_player/video_player.dart';

class StoryVideoTile extends StatefulWidget {
  final String videoUrl;
  final double size;

  const StoryVideoTile({super.key, required this.videoUrl, this.size = 220});

  @override
  State<StoryVideoTile> createState() => _StoryVideoTileState();
}

class _StoryVideoTileState extends State<StoryVideoTile> {
  late VideoPlayerController _controller;

  bool _initialized = false;
  bool _isPlaying = false;
  bool _isNotFinished = false;
  bool _isEnded = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

    _controller.initialize().then((_) {
      if (!mounted) return;

      setState(() {
        _initialized = true;
      });

      _controller.setLooping(false);
    });

    _controller.addListener(() {
      if (!mounted) return;

      setState(() {
        _isNotFinished =
            _controller.value.position < _controller.value.duration &&
            _controller.value.duration != Duration.zero;
        _isEnded =
            _controller.value.position >= _controller.value.duration &&
            _controller.value.duration != Duration.zero;
        _isPlaying = _controller.value.isPlaying;
      });
    });
  }

  double get _progress {
    final duration = _controller.value.duration.inMilliseconds;
    final position = _controller.value.position.inMilliseconds;

    if (duration == 0) return 0;

    return position / duration;
  }

  void _togglePlayback() {
    if (_controller.value.position >= _controller.value.duration) {
      _controller.seekTo(Duration.zero);
      _controller.play();
      return;
    }
    if (_isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayback,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_isNotFinished)
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _ProgressBorderPainter(
                  progress: _progress,
                  progressColor: context.color.purple,
                ),
              ),

            Container(
              width: widget.size - 10,
              height: widget.size - 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.black,
              ),
              clipBehavior: Clip.hardEdge,
              child: _initialized
                  ? FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _ProgressBorderPainter extends CustomPainter {
  final double progress;
  final Color progressColor;

  _ProgressBorderPainter({required this.progress, required this.progressColor});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 2.0;

    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final radius = Radius.circular(28);

    final rrect = RRect.fromRectAndRadius(rect, radius);

    canvas.drawRRect(rrect, backgroundPaint);

    final path = Path()..addRRect(rrect);

    final metric = path.computeMetrics().first;

    final extractPath = metric.extractPath(
      0,
      metric.length * progress.clamp(0.0, 1.0),
    );

    canvas.drawPath(extractPath, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _ProgressBorderPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
