import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';
import '../../../models/game.dart';
import '../../../theme/extensions/game_card_theme.dart';
import '../../../theme/extensions/glass_surface_theme.dart';
import 'game_icon.dart';
import 'game_regions_translator.dart';

/// A games/applications list row. Its panel and icon-box styling come entirely from
/// [GlassSurfaceTheme] and [GameCardTheme], so this single widget renders both the Azahar and
/// Legacy looks.
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
    final surfaceTheme = Theme.of(context).extension<GlassSurfaceTheme>()!;
    final cardTheme = Theme.of(context).extension<GameCardTheme>()!;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: _isValidExtension ? surfaceTheme.fillColor : cardTheme.invalidExtensionColor,
        borderRadius: surfaceTheme.borderRadius,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: surfaceTheme.borderRadius,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: surfaceTheme.borderRadius,
              border: Border.all(
                color: surfaceTheme.borderColor,
                width: surfaceTheme.borderWidth,
              ),
            ),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Container(
                  width: cardTheme.iconBoxSize,
                  height: cardTheme.iconBoxSize,
                  decoration: BoxDecoration(
                    color: cardTheme.iconBoxFillColor,
                    borderRadius: cardTheme.iconBoxRadius,
                    border: Border.all(color: cardTheme.iconBoxBorderColor),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: GameIcon(iconPath: game.iconPath),
                ),
                const SizedBox(width: 12),
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
                          style: cardTheme.titleStyle,
                        ),
                      if (game.company.isNotEmpty)
                        Text(
                          game.company,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: cardTheme.subtitleStyle,
                        ),
                      Text(
                        translateGameRegions(context.t, game.regions),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: cardTheme.subtitleStyle,
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
