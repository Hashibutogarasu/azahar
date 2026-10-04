import 'dart:math' as math;

import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/material.dart';

import '../../games/widgets/game_icon.dart';
import 'game_title.dart';

/// The header of the in-game drawer: the icon and the name of the running game, centered on each
/// other and kept to the left, over a background whose lower edge is a wave. The wave moves while
/// the game runs and stops while it is paused, so the header also tells whether the game is
/// running. It extends under the status bar so the background reaches the top of the screen.
class EmulationDrawerHeader extends StatefulWidget {
  const EmulationDrawerHeader({
    super.key,
    required this.gamePath,
    required this.game,
    required this.isPaused,
    this.trailing,
  });

  final String gamePath;
  final Game? game;
  final bool isPaused;
  final Widget? trailing;

  @override
  State<EmulationDrawerHeader> createState() => _EmulationDrawerHeaderState();
}

class _EmulationDrawerHeaderState extends State<EmulationDrawerHeader>
    with SingleTickerProviderStateMixin {
  static const _wavePeriod = Duration(seconds: 3);
  static const _waveHeight = 16.0;

  late final AnimationController _wave = AnimationController(
    vsync: this,
    duration: _wavePeriod,
  );

  @override
  void initState() {
    super.initState();
    if (!widget.isPaused) _wave.repeat();
  }

  @override
  void didUpdateWidget(EmulationDrawerHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPaused == oldWidget.isPaused) return;
    if (widget.isPaused) {
      _wave.stop();
    } else {
      _wave.repeat();
    }
  }

  @override
  void dispose() {
    _wave.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final content = ColoredBox(
      color: colors.primaryContainer,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24 + MediaQuery.paddingOf(context).top,
          8,
          16 + _waveHeight,
        ),
        child: IconTheme.merge(
          data: IconThemeData(color: colors.onPrimaryContainer),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          width: 96,
                          height: 96,
                          child: GameIcon(iconPath: widget.game?.iconPath),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GameTitle(
                        gamePath: widget.gamePath,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: colors.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ?widget.trailing,
            ],
          ),
        ),
      ),
    );
    return AnimatedBuilder(
      animation: _wave,
      child: content,
      builder: (context, child) => ClipPath(
        clipper: _WaveClipper(phase: _wave.value, height: _waveHeight),
        child: child,
      ),
    );
  }
}

/// Cuts the lower edge of the header into a wave. [phase] moves the wave along its length, from
/// 0 to 1 for one wavelength, so repeating it from 0 to 1 makes the wave flow without a jump.
class _WaveClipper extends CustomClipper<Path> {
  const _WaveClipper({required this.phase, required this.height});

  static const _wavesAcross = 1.5;
  static const _step = 2.0;

  final double phase;
  final double height;

  @override
  Path getClip(Size size) {
    final amplitude = height / 2;
    final baseline = size.height - amplitude;
    final path = Path()..lineTo(0, _waveY(0, size.width, baseline, amplitude));
    for (var x = _step; x < size.width; x += _step) {
      path.lineTo(x, _waveY(x, size.width, baseline, amplitude));
    }
    path
      ..lineTo(size.width, _waveY(size.width, size.width, baseline, amplitude))
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  double _waveY(double x, double width, double baseline, double amplitude) {
    final angle = 2 * math.pi * (x / width * _wavesAcross + phase);
    return baseline + amplitude * math.sin(angle);
  }

  @override
  bool shouldReclip(_WaveClipper oldClipper) =>
      oldClipper.phase != phase || oldClipper.height != height;
}
