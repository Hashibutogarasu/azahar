import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/games/game_title_provider.dart';

/// The name of the running game, rendered as empty text while the game is not known yet.
class GameTitle extends ConsumerWidget {
  const GameTitle({
    super.key,
    required this.gamePath,
    this.style,
    this.maxLines,
    this.overflow,
  });

  final String gamePath;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      ref.watch(gameTitleProvider(gamePath)),
      style: style,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
