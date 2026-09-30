import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/material.dart';

/// The title of the running [game], rendered as empty text while the game is not known yet.
class GameTitle extends StatelessWidget {
  const GameTitle({
    super.key,
    required this.game,
    this.style,
    this.maxLines,
    this.overflow,
  });

  final Game? game;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      game?.title ?? '',
      style: style,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
