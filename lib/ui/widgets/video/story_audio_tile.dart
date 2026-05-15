import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class StoryAudioTile extends StatefulWidget {
  final String audioUrl;
  final double size;

  const StoryAudioTile({super.key, required this.audioUrl, this.size = 200});

  @override
  State<StoryAudioTile> createState() => _StoryAudioTileState();
}

class _StoryAudioTileState extends State<StoryAudioTile> {
  late final AudioPlayer _player;

  bool _initialized = false;
  bool _isPlaying = false;
  bool _isWatched = false;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();

    _initAudio();

    _player.positionStream.listen((position) {
      if (!mounted) return;

      setState(() {
        _position = position;
      });

      if (_duration != Duration.zero && position >= _duration) {
        setState(() {
          _isWatched = true;
          _isPlaying = false;
        });
      }
    });

    _player.durationStream.listen((duration) {
      if (!mounted || duration == null) return;

      setState(() {
        _duration = duration;
      });
    });

    _player.playerStateStream.listen((state) {
      if (!mounted) return;

      setState(() {
        _isPlaying = state.playing;
      });

      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _isWatched = true;
          _isPlaying = false;
        });
      }
    });
  }

  Future<void> _initAudio() async {
    await _player.setUrl(widget.audioUrl);

    if (!mounted) return;

    setState(() {
      _initialized = true;
    });
  }

  double get _progress {
    if (_duration.inMilliseconds == 0) return 0;

    return _position.inMilliseconds / _duration.inMilliseconds;
  }

  Future<void> _togglePlayback() async {
    if (!_initialized) return;

    if (_player.processingState == ProcessingState.completed ||
        (_duration != Duration.zero && _position >= _duration)) {
      await _player.seek(Duration.zero);

      setState(() {
        _isWatched = false;
      });

      await _player.play();
      return;
    }

    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
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
            if (!_isWatched)
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _ProgressBorderPainter(progress: _progress),
              ),

            Container(
              width: widget.size - 10,
              height: widget.size - 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.black,
              ),
              child: Center(
                child: _initialized
                    ? Icon(
                        _isPlaying ? Icons.pause : Icons.mic,
                        size: 56,
                        color: Colors.white,
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

class _ProgressBorderPainter extends CustomPainter {
  final double progress;

  _ProgressBorderPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 4.0;

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
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(28));

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
