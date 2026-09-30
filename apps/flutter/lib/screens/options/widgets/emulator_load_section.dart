import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/settings/emulator_weight_provider.dart';
import '../../../i18n/translations.g.dart';
import '../../settings/widgets/settings_group_card.dart';
import 'widget_settings_item.dart';

/// The section at the top of the Options page that shows how heavy the current settings make the
/// emulation. It is fixed rather than data-driven, and follows [emulatorWeightIndexProvider], so
/// the bar moves as soon as a setting changes.
class EmulatorLoadSection extends ConsumerWidget {
  const EmulatorLoadSection({super.key});

  /// The load below which the bar is green.
  static const lowLimit = 0.4;

  /// The load below which the bar is yellow; from here on it is red.
  static const mediumLimit = 0.7;

  /// The color of the bar for [load]: green while light, yellow while moderate, red while heavy.
  static Color colorFor(double load) {
    if (load < lowLimit) return Colors.green;
    if (load < mediumLimit) return Colors.amber;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final load = ref.watch(emulatorWeightIndexProvider);
    final color = colorFor(load);
    return SettingsGroupCard(
      settingsGroupTitle: t.options.emulatorLoad,
      items: [
        WidgetSettingsItem(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(end: load),
                  duration: const Duration(milliseconds: 250),
                  builder: (context, value, _) => ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: value,
                      minHeight: 12,
                      color: color,
                      backgroundColor: color.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  t.options.emulatorLoadDescription,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
