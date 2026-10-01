import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/settings/feature_flags_provider.dart';
import '../../../theme/extensions/glass_surface_theme.dart';
import '../../../widgets/app_liquid_glass.dart';
import 'tag_color_dot.dart';

/// A single glass chip showing the tag [color] as a dot. When [selected] it is highlighted with the
/// theme's primary color, the same for every tag. It cannot be tapped while [onTap] is null.
class TagChip extends ConsumerWidget {
  const TagChip({
    super.key,
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surfaceTheme = Theme.of(context).extension<GlassSurfaceTheme>()!;
    final highlight = Theme.of(context).colorScheme.primary;
    final radius = BorderRadius.circular(20);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: AppLiquidGlass(
        borderRadius: radius,
        blurSigma: surfaceTheme.blurSigma,
        fillColor: selected
            ? highlight.withValues(alpha: 0.35)
            : surfaceTheme.fillColor,
        borderColor: selected ? highlight : surfaceTheme.borderColor,
        backdropBlur: !ref.watch(performanceImprovementsProvider),
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TagColorDot(color: color),
                  const SizedBox(width: 8),
                  Text(label),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
