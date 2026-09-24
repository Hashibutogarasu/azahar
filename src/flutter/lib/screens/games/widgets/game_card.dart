import 'package:flutter/material.dart';

import '../../../models/game.dart';
import 'game_icon.dart';

class GameCard extends StatelessWidget {
  const GameCard({super.key, required this.game, required this.onTap, this.onLongPress});

  final Game game;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  bool get _isValidExtension {
    final extension = game.filename.split('.').last.toLowerCase();
    return !GameExtensions.badExtensions.contains(extension);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        margin: EdgeInsets.zero,
        color: _isValidExtension ? null : colorScheme.errorContainer,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: colorScheme.outline),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    width: 75,
                    height: 75,
                    child: GameIcon(iconPath: game.iconPath),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (game.title.isNotEmpty)
                        Text(
                          game.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      if (game.company.isNotEmpty)
                        Text(
                          game.company,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      Text(
                        game.regions,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
