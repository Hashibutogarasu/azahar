import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import '../../../data/games/game_title_provider.dart';
import '../../../data/settings/feature_flags_provider.dart';
import '../../../i18n/translations.g.dart';
import '../../../theme/extensions/game_card_theme.dart';
import '../../../theme/extensions/glass_surface_theme.dart';
import '../../../widgets/app_liquid_glass.dart';
import '../../../widgets/gamepad/gamepad_intents.dart';
import 'game_icon.dart';
import 'game_regions_translator.dart';

/// A games/applications list row. Its panel and icon-box styling come entirely from
/// [GlassSurfaceTheme] and [GameCardTheme], so this single widget renders both the Azahar and
/// Legacy looks.
///
/// [onInfo] is called by a long press on the row, by a controller's context menu button, and by
/// the three-dot button shown beside the tappable area when [showInfoButton] is true.
class GameCard extends ConsumerWidget {
  const GameCard({
    super.key,
    required this.game,
    required this.onTap,
    this.onInfo,
    this.showInfoButton = false,
    this.isValidExtension = true,
    this.outerPadding = 8,
    this.innerPadding = 8,
  });

  final Game game;
  final VoidCallback onTap;
  final VoidCallback? onInfo;
  final bool showInfoButton;
  final bool isValidExtension;
  final double outerPadding;
  final double innerPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(gameTitleProvider(game.path));
    final surfaceTheme = Theme.of(context).extension<GlassSurfaceTheme>()!;
    final cardTheme = Theme.of(context).extension<GameCardTheme>()!;
    final performanceImprovements = ref.watch(performanceImprovementsProvider);
    final glass = AppLiquidGlass(
      borderRadius: surfaceTheme.borderRadius,
      blurSigma: surfaceTheme.blurSigma,
      fillColor: isValidExtension
          ? surfaceTheme.fillColor
          : cardTheme.invalidExtensionColor,
      borderColor: surfaceTheme.borderColor,
      backdropBlur: !performanceImprovements,
      shadow: performanceImprovements ? const [] : surfaceTheme.shadow,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
              onLongPress: onInfo,
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
                      child: GameIcon(
                        iconPath: game.iconPath,
                        cacheSize: performanceImprovements
                            ? cardTheme.iconBoxSize
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title.isNotEmpty)
                            Text(
                              title,
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
          if (showInfoButton)
            IconButton(
              tooltip: context.t.games.properties,
              icon: const Icon(Icons.more_vert),
              onPressed: onInfo,
            ),
        ],
      ),
    );
    final info = onInfo;
    final card = Padding(
      padding: EdgeInsets.all(outerPadding),
      child: performanceImprovements ? RepaintBoundary(child: glass) : glass,
    );
    if (info == null) return card;
    return Actions(
      actions: {
        OpenContextMenuIntent: CallbackAction<OpenContextMenuIntent>(
          onInvoke: (_) => info(),
        ),
      },
      child: card,
    );
  }
}
