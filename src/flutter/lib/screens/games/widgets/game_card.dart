import 'package:flutter/material.dart';
import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import '../../../i18n/translations.g.dart';
import '../../../theme/extensions/game_card_theme.dart';
import '../../../theme/extensions/glass_surface_theme.dart';
import '../../../widgets/app_liquid_glass.dart';
import 'game_icon.dart';
import 'game_regions_translator.dart';

/// A games/applications list row. Its panel and icon-box styling come entirely from
/// [GlassSurfaceTheme] and [GameCardTheme], so this single widget renders both the Azahar and
/// Legacy looks.
class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.game,
    required this.onTap,
    this.onLongPress,
    this.isValidExtension = true,
    this.outerPadding = 8,
    this.innerPadding = 8,
  });

  final Game game;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool isValidExtension;
  final double outerPadding;
  final double innerPadding;

  @override
  Widget build(BuildContext context) {
    final surfaceTheme = Theme.of(context).extension<GlassSurfaceTheme>()!;
    final cardTheme = Theme.of(context).extension<GameCardTheme>()!;
    return Padding(
      padding: EdgeInsets.all(outerPadding),
      child: AppLiquidGlass(
        borderRadius: surfaceTheme.borderRadius,
        blurSigma: surfaceTheme.blurSigma,
        fillColor: isValidExtension
            ? surfaceTheme.fillColor
            : cardTheme.invalidExtensionColor,
        borderColor: surfaceTheme.borderColor,
        shadow: surfaceTheme.shadow,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: surfaceTheme.borderRadius,
          child: Container(
            padding: EdgeInsets.all(innerPadding),
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
