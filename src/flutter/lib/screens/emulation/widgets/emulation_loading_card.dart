import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';
import '../../../models/game.dart';
import '../../../models/shader_cache_progress.dart';
import '../../games/widgets/game_icon.dart';

/// Loading card shown over the emulation screens until the game has started, mirroring the
/// original Android `loading_indicator` in `fragment_emulation.xml`.
class EmulationLoadingCard extends StatelessWidget {
  const EmulationLoadingCard({
    super.key,
    required this.game,
    required this.progress,
  });

  final Game? game;
  final ShaderCacheProgress? progress;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final textTheme = Theme.of(context).textTheme;
    final current = progress;
    final isFinished = current == null || current.progress == current.max;
    final isCounting = !isFinished && current.progress > 0;

    final String message;
    if (isFinished) {
      message = t.emulation.loading;
    } else if (current.stage == ShaderCacheStage.build) {
      message = t.emulation.buildingShaders;
    } else {
      message = t.emulation.preparingShaders;
    }

    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: GameIcon(iconPath: game?.iconPath),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(game?.title ?? '', style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(message, style: textTheme.titleSmall),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 192,
                    child: LinearProgressIndicator(
                      value: isCounting ? current.progress / current.max : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  if (isCounting) ...[
                    const SizedBox(height: 4),
                    Text(
                      t.emulation.shaderProgress(
                        progress: current.progress,
                        max: current.max,
                      ),
                      style: textTheme.labelSmall,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
