import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/// A customizable audio waveform player widget with animated transitions,
/// play-pulse effects, and dynamic theming.
///
/// This widget provides:
/// - Animated waveform visualization
/// - Play/pause controls with pulse animation
/// - Speed control (1.0x, 1.5x, 2.0x)
/// - Seek functionality via tap and drag
/// - Customizable colors and gradients
/// - Responsive design
///
/// Example usage:
/// ```dart
/// InnovareAudioWaveformPlayer(
///   uri: 'https://example.com/audio.mp3',
///   waveform: [0.1, 0.3, 0.7, 0.4, 0.8, 0.2, 0.9],
///   height: 40,
///   accentColor: Colors.blue,
///   backgroundColor: Colors.grey.shade900,
/// )
/// ```
class InnovareAudioWaveformPlayer extends StatefulWidget {

  /// Creates an [InnovareAudioWaveformPlayer].
  ///
  /// The [uri] and [waveform] parameters are required.
  /// The [height] defaults to 30.0.
  /// The [accentColor] defaults to [Colors.blueAccent].
  /// The [backgroundColor] defaults to a dark gray color.
  const InnovareAudioWaveformPlayer({
    super.key,
    required this.uri,
    required this.waveform,
    this.height = 30,
    this.accentColor = Colors.blueAccent,
    this.backgroundColor = const Color(0xFF1C1C1E),
    this.playedWaveformGradient,
  }) : assert(height > 0, 'Height must be positive');
  /// The audio file URI to play
  final String uri;

  /// List of normalized waveform amplitudes (0.0 to 1.0)
  final List<double> waveform;

  /// Height of the waveform visualization
  final double height;

  /// Primary accent color for the player
  final Color accentColor;

  /// Background color of the player container
  final Color backgroundColor;

  /// Optional gradient for the played portion of the waveform
  final Gradient? playedWaveformGradient;

  @override
  State<InnovareAudioWaveformPlayer> createState() =>
      _InnovareAudioWaveformPlayerState();
}

class _InnovareAudioWaveformPlayerState extends State<InnovareAudioWaveformPlayer>
    with SingleTickerProviderStateMixin {
  late final AudioPlayer _player;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _speed = 1.0;
  bool _isDragging = false;
  double? _dragPercent;

  static const _speedOptions = [1.0, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    _initializePulseAnimation();
    _initializeAudioPlayer();
  }

  void _initializePulseAnimation() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.4)
        .animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));
    _pulseController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseController.reverse();
      }
    });
  }

  void _initializeAudioPlayer() {
    _player = AudioPlayer();

    _player.setUrl(widget.uri).then((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      final d = _player.duration;
      if (d != null && mounted) {
        setState(() => _duration = d);
      }
    }).catchError((Object error, stackTrace) {
      debugPrint('Error loading audio: $error');
    });

    _player.positionStream.listen((pos) {
      if (!_isDragging && mounted) {
        setState(() => _position = pos);
      }
    });

    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _player
          ..pause()
          ..seek(Duration.zero);
        if (mounted) {
          setState(() {
            _position = Duration.zero;
            _dragPercent = null;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _player.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    _pulseController.forward(from: 0);
    if (_player.playing) {
      _player.pause();
    } else {
      if (_position >= _duration) {
        _player.seek(Duration.zero);
      }
      _player.play();
    }
  }

  void _cycleSpeed() {
    final idx = _speedOptions.indexOf(_speed);
    final next = _speedOptions[(idx + 1) % _speedOptions.length];
    setState(() {
      _speed = next;
      _player.setSpeed(_speed);
    });
  }

  void _seekToPercent(double percent) {
    final newPos = _duration * percent;
    _player.seek(newPos);
    setState(() {
      _position = newPos;
      _isDragging = false;
      _dragPercent = null;
    });
  }

  List<double> get _normalizedWaveform {
    if (widget.waveform.isEmpty) {
      return [0.05];
    }

    final valid = widget.waveform.where((e) => e > 0).toList();
    if (valid.isEmpty) {
      return List.filled(widget.waveform.length, 0.05);
    }

    final peak = valid.reduce(max);
    return widget.waveform.map((v) {
      final n = (v / peak).clamp(0.0, 1.0);
      return n * 0.95 + 0.05;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.45;
    final percent = _duration.inMilliseconds == 0
        ? 0.0
        : (_dragPercent ?? _position.inMilliseconds / _duration.inMilliseconds);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth, minHeight: widget.height),
        child: Container(
          color: widget.backgroundColor,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPlayerControls(maxWidth, percent),
              const SizedBox(height: 8),
              _buildTimeDisplay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerControls(double maxWidth, double percent) => Row(
      spacing: 5.0,
      children: [
        _buildPlayButton(),
        Expanded(child: _buildWaveform(maxWidth, percent)),
        _buildSpeedControl(),
      ],
    );

  Widget _buildPlayButton() => ScaleTransition(
      scale: _pulseAnimation,
      child: IconButton(
        icon: Icon(
          _player.playing
              ? Icons.pause_circle_filled
              : Icons.play_circle_fill,
          size: 32,
          color: Colors.white,
        ),
        onPressed: _togglePlayPause,
      ),
    );

  Widget _buildWaveform(double maxWidth, double percent) => GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: (d) {
        final x = d.localPosition.dx;
        setState(() {
          _isDragging = true;
          _dragPercent = (x / maxWidth).clamp(0.0, 1.0);
        });
      },
      onHorizontalDragEnd: (_) {
        if (_dragPercent != null) {
          _seekToPercent(_dragPercent!);
        }
      },
      onTapDown: (d) {
        final x = d.localPosition.dx;
        _seekToPercent((x / maxWidth).clamp(0.0, 1.0));
      },
      child: SizedBox(
        width: double.infinity,
        height: widget.height,
        child: TweenAnimationBuilder<Color?>(
          tween: ColorTween(
            begin: widget.accentColor.withValues(alpha: 0.6),
            end: widget.accentColor,
          ),
          duration: const Duration(milliseconds: 200),
          builder: (_, color, __) => CustomPaint(
              painter: _WaveformPainter(
                waveform: _normalizedWaveform,
                progress: percent,
                accentColor: color ?? widget.accentColor,
                gradient: widget.playedWaveformGradient,
              ),
            ),
        ),
      ),
    );

  Widget _buildSpeedControl() => GestureDetector(
      onTap: _cycleSpeed,
      child: Container(
        width: 36,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.accentColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '${_speed.toStringAsFixed(1)}x',
          style: TextStyle(
            color: widget.accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );

  Widget _buildTimeDisplay() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
            fontFamily: 'RobotoMono',
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );

  String _formatDuration(Duration d) =>
      d.toString().split('.').first.padLeft(8, '0');
}

class _WaveformPainter extends CustomPainter {

  const _WaveformPainter({
    required this.waveform,
    required this.progress,
    required this.accentColor,
    this.gradient,
  });
  final List<double> waveform;
  final double progress;
  final Color accentColor;
  final Gradient? gradient;

  @override
  void paint(Canvas canvas, Size size) {
    if (waveform.isEmpty || size.width <= 0 || size.height <= 0) {
      return;
    }

    final paintBg = Paint()..color = accentColor.withValues(alpha: 0.15);

    final paintFg = Paint()
      ..shader = (gradient ??
          LinearGradient(colors: [accentColor, accentColor]))
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final barWidth = size.width / waveform.length;
    final centerY = size.height / 2;

    for (var i = 0; i < waveform.length; i++) {
      final x = i * barWidth;
      final h = max(waveform[i] * size.height, 2.0);
      final played = i / waveform.length < progress;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, centerY - h / 2, barWidth * 0.8, h),
          const Radius.circular(2),
        ),
        played ? paintFg : paintBg,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter old) => old.progress != progress ||
        old.waveform != waveform ||
        old.accentColor != accentColor ||
        old.gradient != gradient;
}
