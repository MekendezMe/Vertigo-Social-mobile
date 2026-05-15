import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';

class VoiceMessagePlayer extends StatefulWidget {
  final String audioUrl;

  const VoiceMessagePlayer({super.key, required this.audioUrl});

  @override
  State<VoiceMessagePlayer> createState() => _VoiceMessagePlayerState();
}

class _VoiceMessagePlayerState extends State<VoiceMessagePlayer> {
  late final AudioPlayer _player;

  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();
    _initAudio();

    _player.positionStream.listen((position) {
      if (!mounted) return;
      setState(() => _position = position);
    });

    _player.durationStream.listen((duration) {
      if (!mounted || duration == null) return;
      setState(() => _duration = duration);
    });

    _player.playerStateStream.listen((state) {
      if (!mounted) return;
      setState(() => _isPlaying = state.playing);

      if (state.processingState == ProcessingState.completed) {
        _player.pause();
        _player.seek(Duration.zero);

        setState(() {
          _position = Duration.zero;
          _isPlaying = false;
        });
      }
    });
  }

  Future<void> _initAudio() async {
    try {
      await _player.setUrl(widget.audioUrl);
    } catch (e) {
      debugPrint('Audio load error: $e');
    }
  }

  double get _progress {
    if (_duration.inMilliseconds == 0) return 0;
    return _position.inMilliseconds / _duration.inMilliseconds;
  }

  Future<void> _toggle() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Duration get _remaining {
    final remaining = _duration - _position;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  String _format(Duration duration) {
    final totalSeconds = (duration.inMilliseconds / 1000).ceil();

    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');

    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: context.color.purple.withOpacity(0.3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _toggle,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: context.color.lightPurple,
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _progress.clamp(0.0, 1.0),
                minHeight: 4,
                backgroundColor: Colors.grey.withOpacity(0.5),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(_format(_remaining), style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
